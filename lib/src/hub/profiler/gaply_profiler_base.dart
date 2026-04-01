import 'dart:async';
import 'dart:isolate';

import 'package:gaply/src/hub/logger/gaply_logger_base.dart';
import 'package:gaply/src/hub/logger/gaply_logger.dart';
import 'package:gaply/src/hub/gaply_hub.dart';

abstract class GaplyProfilerEngine<T extends GaplyProfilerStats> {
  final GaplyLoggerEngine? customLogger;
  final Duration threshold;
  final int maxKeys;
  final Duration maxIdleTime;

  Map<String, T> statsMap = {};
  Timer? _cleanupTimer;
  late SendPort _cachedPort;

  GaplyProfilerEngine({
    required this.threshold,
    required this.maxKeys,
    required this.maxIdleTime,
    this.customLogger,
  }) {
    final channel =
        GaplyHub.getChannel(category) ??
        GaplyHub.createChannel(category, (packet) {
          if (packet is ProfilePacket) {
            _handleIncomingPacket(packet);
          }
        });

    _cachedPort = channel.sendPort;

    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _performCleanup();
    });
  }

  String get category;

  void onPacketReceived(ProfilePacket packet);
  void record(ProfilePacket packet);

  void _handleIncomingPacket(ProfilePacket packet) {
    if (statsMap.length >= maxKeys) {
      statsMap.clear();
      warningLog('⚠️ [Gaply] $category: Memory limit reached. Map cleared.');
    }
    onPacketReceived(packet);
  }

  void _performCleanup() {
    final now = DateTime.now();
    statsMap.removeWhere((key, stats) {
      final isIdle = now.difference(stats.lastLogTime) > maxIdleTime;
      if (isIdle && stats.isNotEmpty) {
        stats.dispose();
      }
      return isIdle;
    });
  }

  void printStats(String label) {
    statsMap.entries.where((e) => e.key.startsWith(label)).forEach((e) => e.value.printSummary(label));
  }

  Future<void> dispose() async {
    for (var stats in statsMap.values) {
      await stats.dispose();
    }
    _cleanupTimer?.cancel();
  }

  void sendPacket(ProfilePacket packet) {
    _cachedPort.send(packet);
  }
}

extension GaplyProfilerEngineX on GaplyProfilerEngine {
  void debugLog(String text, {bool isForce = false}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.debug, isForce, engineId: customLogger?.id);
  }

  void infoLog(String text, {bool isForce = false}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.info, isForce, engineId: customLogger?.id);
  }

  void warningLog(String text, {bool isForce = true}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.warning, isForce, engineId: customLogger?.id);
  }

  void errorLog(String text, {bool isForce = true}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.error, isForce, engineId: customLogger?.id);
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

class ProfilePacket {
  final Duration elapsed;
  final String label;
  final String? tag;
  final bool isAsync;
  final int depth;
  final int memoryDelta;

  ProfilePacket({
    required this.elapsed,
    required this.label,
    this.tag,
    required this.isAsync,
    required this.depth,
    required this.memoryDelta,
  });
}
