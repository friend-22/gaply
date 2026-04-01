import 'dart:async';
import 'dart:isolate';
import 'gaply_profiler_base.dart';
import '../logger/gaply_logger_base.dart';

mixin GaplyProfilerMixin<T extends GaplyProfilerStats> {
  GaplyProfilerEngine get _self => this as GaplyProfilerEngine;

  Map<String, T> get statsMap;
  int get maxKeys;
  Duration get maxIdleTime;
  String get category;

  static final ReceivePort _receivePort = ReceivePort();
  static bool _isInitialized = false;

  Timer? _cleanupTimer;

  static SendPort get _sendPort => _receivePort.sendPort;

  void initMasterListener(Function(ProfilePacket) onMessage) {
    if (_isInitialized) return;
    _isInitialized = true;

    _receivePort.listen((packet) {
      if (packet is ProfilePacket) {
        if (statsMap.length >= maxKeys) {
          statsMap.clear();
          _self.warningLog('⚠️ [Gaply] $category: Memory limit reached. Map cleared.');
        }
        onMessage(packet);
      }
    });

    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _cleanupOldEntries();
    });
  }

  void sendPacket(ProfilePacket packet) {
    _sendPort.send(packet);
  }

  void _cleanupOldEntries() {
    final now = DateTime.now();
    statsMap.removeWhere((key, stats) {
      final lastActive = stats.lastLogTime;
      final isIdle = now.difference(lastActive) > maxIdleTime;
      if (isIdle && stats.isNotEmpty) {
        stats.flush();
      }
      return isIdle;
    });
  }

  void printStats(String label) {
    statsMap.entries.where((e) => e.key.startsWith(label)).forEach((e) => e.value.printSummary(label));
  }

  Future<void> dispose() async {
    _cleanupTimer?.cancel();
    _receivePort.close();
  }
}
