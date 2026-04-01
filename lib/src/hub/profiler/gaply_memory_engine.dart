import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'gaply_profiler_base.dart';
import 'gaply_profiler_mixin.dart';

/// [GaplyMemoryEngine] - Focused on tracking memory allocation and leaks
class GaplyMemoryEngine extends GaplyProfilerEngine with GaplyProfilerMixin<MemoryStats> {
  final int thresholdBytes;
  @override
  String get category => 'Trace';
  @override
  final int maxKeys;
  @override
  final Duration maxIdleTime;
  @override
  Map<String, MemoryStats> get statsMap => _statsMap;

  static final Map<String, MemoryStats> _statsMap = {};

  GaplyMemoryEngine({
    super.customLogger,
    this.thresholdBytes = GaplyBudget.zeroBytes, // Default: log all memory changes
    this.maxKeys = 500,
    this.maxIdleTime = const Duration(minutes: 5),
  }) {
    initMasterListener((packet) {
      final stats = statsMap.putIfAbsent(packet.label, () => MemoryStats(engine: this));

      stats.add(packet.memoryDelta, thresholdBytes);

      if (packet.memoryDelta.abs() >= thresholdBytes) {
        _log(packet.memoryDelta, label: packet.label, tag: packet.tag, depth: packet.depth);
      }
    });
  }

  @override
  void record(ProfilePacket packet) {
    sendPacket(packet);
  }

  void _log(int delta, {required String label, String? tag, required int depth}) {
    final a = GaplyHub.theme.ansi;
    final String formatted = GaplyBudget.formatBytes(delta);

    final String color = delta > 0 ? a.jank : a.perf;
    final String indent = depth > 0 ? '${'  ' * depth}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    String percentStr = '';
    if (thresholdBytes > 0) {
      final double p = (delta.abs() / thresholdBytes) * 100;
      percentStr = ' ${a.gray}(${p.toStringAsFixed(1)}%)${a.reset}';
    }

    infoLog(
      '${a.gray}[MEM]${a.reset} $indent${a.label}$label${a.reset}$tagStr : '
      '$color${formatted.padLeft(10)}${a.reset}$percentStr',
    );
  }
}

class MemoryStats implements GaplyProfilerStats {
  final GaplyMemoryEngine engine;

  int count = 0;
  int totalDelta = 0;
  int peakDelta = 0;
  int minDelta = 0;
  int lastThresholdBytes = 0;

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => count > 0;

  MemoryStats({required this.engine});

  void add(int delta, int thresholdBytes) {
    count++;
    totalDelta += delta;
    lastThresholdBytes = thresholdBytes;
    lastLogTime = DateTime.now();

    if (delta > peakDelta) peakDelta = delta;
    if (delta < minDelta) minDelta = delta;
  }

  double get avgDelta => totalDelta / count;

  @override
  void printSummary(String label) {
    final a = GaplyHub.theme.ansi;

    final String avgStr = GaplyBudget.formatBytes((totalDelta / count).toInt());
    final String peakStr = GaplyBudget.formatBytes(peakDelta);
    final String minStr = GaplyBudget.formatBytes(minDelta);
    final String limitStr = GaplyBudget.formatBytes(lastThresholdBytes);

    final bool isOver = lastThresholdBytes > 0 && peakDelta > lastThresholdBytes;
    final String peakColor = isOver ? a.accent : a.label;

    String offsetStr = '';
    if (lastThresholdBytes > 0) {
      final int diff = peakDelta - lastThresholdBytes;
      final String sign = diff > 0 ? '+' : '';
      final String diffColor = diff > 0 ? a.jank : a.gray;
      offsetStr = ' ${a.gray}($diffColor$sign${GaplyBudget.formatBytes(diff)}${a.gray})${a.reset}';
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
}
