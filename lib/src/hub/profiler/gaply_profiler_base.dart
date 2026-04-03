part of 'gaply_profiler.dart';

abstract class GaplyProfilerEngine<T extends GaplyProfilerStats> {
  GaplyEngineSpec get spec;

  Map<String, T> statsMap = {};
  Timer? _cleanupTimer;

  late GaplyChannel _channel;
  late String _channelId;
  late SendPort _channelPort;
  late String _listenerId;

  GaplyProfilerEngine() {
    _channelId = _getGroupedChannelId(category, spec.threshold);
    _channel = GaplyChannelPool.getChannel(_channelId);
    _listenerId = _channel.registerListener(spec.id, (data) {
      if (data is List) {
        handleIncomingData(data);
      }
    });
    _channelPort = _channel.sendPort;

    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _performCleanup();
    });
  }

  String _getGroupedChannelId(String category, Duration threshold) {
    final int ms = threshold.inMilliseconds;

    if (ms <= 0) return 'Gaply_${category}_All';

    if (ms <= 33) return 'Gaply_${category}_Fast';

    final int group = (ms / 50).floor() * 50;
    return 'Gaply_${category}_${group}ms';
  }

  String get category;

  void record(dynamic data);
  void onDataReceived(dynamic data);

  void handleIncomingData(dynamic data) {
    if (statsMap.length >= spec.maxStats) {
      statsMap.clear();
      warningLog('⚠️ [Gaply] $category: Map Keys limit reached. Map cleared.');
    }
    onDataReceived(data);
  }

  void _performCleanup() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    statsMap.forEach((key, stats) {
      if (now.difference(stats.lastLogTime) > spec.statsLifetime) {
        keysToRemove.add(key);
      }
    });

    for (var key in keysToRemove) {
      statsMap[key]?.dispose();
      statsMap.remove(key);
    }
  }

  Future<void> printStats(String label) async {
    await _channel.waitForPendingMessages();
    statsMap.entries.where((e) => e.key.startsWith(label)).forEach((e) => e.value.printSummary(label));
  }

  Future<void> dispose() async {
    await _channel.waitForPendingMessages();

    for (var stats in statsMap.values) {
      await stats.dispose();
    }

    _cleanupTimer?.cancel();
    _cleanupTimer = null;

    statsMap.clear();

    _channel.removeListener(_listenerId);
  }

  void sendPacket(dynamic payload) {
    _channelPort.sendPacket(_listenerId, payload);
  }
}

extension GaplyProfilerEngineX on GaplyProfilerEngine {
  void debugLog(String text, {bool isImmediate = false}) {
    GaplyHub.dispatch(text, GaplyLogLevel.debug, isImmediate, engineId: spec.customLogger?.id);
  }

  void infoLog(String text, {bool isImmediate = false}) {
    GaplyHub.dispatch(text, GaplyLogLevel.info, isImmediate, engineId: spec.customLogger?.id);
  }

  void warningLog(String text, {bool isImmediate = true}) {
    GaplyHub.dispatch(text, GaplyLogLevel.warning, isImmediate, engineId: spec.customLogger?.id);
  }

  void errorLog(String text, {bool isImmediate = true}) {
    GaplyHub.dispatch(text, GaplyLogLevel.error, isImmediate, engineId: spec.customLogger?.id);
  }
}

abstract class GaplyProfilerStats {
  const GaplyProfilerStats();

  bool get isNotEmpty;
  DateTime get lastLogTime;

  void flush();
  void printSummary(String label);

  Future<void> dispose();
}

abstract class ProfilerIdx {
  static const int sw = 0; // Stopwatch or Microseconds
  static const int id = 1; // Profiler ID
  static const int tag = 2; // Custom Tag
  static const int isAsync = 3; // IsAsync Flag (0 or 1)
  static const int depth = 4; // Depth
  static const int memDelta = 5; // Memory Delta
  static const int metadata = 6; // Metadata Map
}
