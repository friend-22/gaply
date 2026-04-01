import 'dart:async';

import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'gaply_profiler_base.dart';

/// [GaplyMemoryEngine] - Focused on tracking memory allocation and leaks
class GaplyMemoryEngine extends GaplyProfilerEngine<MemoryStats> {
  final int thresholdBytes;

  @override
  String get category => 'Memory';

  GaplyMemoryEngine({
    super.customLogger,
    this.thresholdBytes = GaplyBudget.mb1,
    int? maxKeys,
    Duration? maxIdleTime,
  }) : super(
         threshold: GaplyBudget.all,
         maxKeys: maxKeys ?? 500,
         maxIdleTime: maxIdleTime ?? const Duration(minutes: 5),
       );

  @override
  void onPacketReceived(ProfilePacket packet) {
    final stats = statsMap.putIfAbsent(
      packet.label,
      () => MemoryStats(engine: this, thresholdBytes: thresholdBytes),
    );

    stats.add(packet.memoryDelta);

    if (packet.memoryDelta.abs() >= thresholdBytes) {
      _log(packet.memoryDelta, label: packet.label, tag: packet.tag, depth: packet.depth);
    }
  }

  @override
  void record(ProfilePacket packet) {
    sendPacket(packet);
  }

  void _log(int delta, {required String label, String? tag, required int depth}) {
    final a = GaplyHub.theme.ansi;
    final String formatted = GaplyBudget.formatBytes(delta);

    final String icon = delta > 0 ? '📈' : '📉';
    final String color = delta > 0 ? a.jank : a.perf;
    final String indent = depth > 0 ? '${'  ' * depth}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    infoLog(
      '${a.gray}[MEM]${a.reset} $indent$icon ${a.label}$label${a.reset}$tagStr : '
      '$color${formatted.padLeft(10)}${a.reset}',
    );
  }
}

class MemoryStats implements GaplyProfilerStats {
  final GaplyMemoryEngine engine;
  final int thresholdBytes;

  int count = 0;
  int totalDelta = 0;
  int peakDelta = 0;
  int minDelta = 0;
  int lastThresholdBytes = 0;

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => count > 0;

  MemoryStats({required this.engine, required this.thresholdBytes});

  void add(int delta) {
    count++;
    totalDelta += delta;
    lastLogTime = DateTime.now();

    if (delta > peakDelta) peakDelta = delta;
    if (delta < minDelta) minDelta = delta;
  }

  @override
  void printSummary(String label) {
    if (count == 0) return;

    final a = GaplyHub.theme.ansi;

    final String avgStr = GaplyBudget.formatBytes((totalDelta ~/ count));
    final String peakStr = GaplyBudget.formatBytes(peakDelta);
    final String minStr = GaplyBudget.formatBytes(minDelta);
    final String limitStr = GaplyBudget.formatBytes(thresholdBytes);

    final bool isOver = thresholdBytes > 0 && peakDelta > thresholdBytes;
    final String peakColor = isOver ? a.accent : a.label;

    String offsetStr = '';
    if (thresholdBytes > 0) {
      final int diff = peakDelta - thresholdBytes;
      if (diff > 0) {
        offsetStr = ' ${a.gray}(${a.jank}+${GaplyBudget.formatBytes(diff)}${a.gray})${a.reset}';
      }
    }

    engine.infoLog(
      '🧠 ${a.label}[MEMORY STATS] $label${a.reset} ${a.gray}(Budget: $limitStr)${a.reset}\n'
      '   Calls: $count | '
      'Avg Delta: ${a.label}$avgStr${a.reset} | '
      'Peak: $peakColor$peakStr$offsetStr${a.reset} | '
      'Min: ${a.perf}$minStr${a.reset}',
      isForce: true,
    );
  }

  @override
  void flush() {}

  @override
  Future<void> dispose() async {}
}
