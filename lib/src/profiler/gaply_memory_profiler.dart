import 'gaply_budget.dart';
import 'gaply_profiler.dart';
import 'gaply_logger.dart';

/// [GaplyMemoryEngine] - Focused on tracking memory allocation and leaks
class GaplyMemoryEngine implements GaplyProfileEngine {
  final int thresholdBytes; // Logging threshold (e.g., only log if > 1MB)
  static final Map<String, _MemoryStats> _statsMap = {};

  GaplyMemoryEngine({
    this.thresholdBytes = GaplyBudget.zeroBytes, // Default: log all memory changes
  });

  @override
  void record(
    Duration elapsed, {
    required int memoryDelta,
    required String label,
    String? tag,
    int? depth,
    bool isAsync = false,
  }) {
    _statsMap.putIfAbsent(label, () => _MemoryStats()).add(memoryDelta, thresholdBytes);

    // Only log if the absolute change exceeds the threshold
    if (memoryDelta.abs() < thresholdBytes) return;

    _log(memoryDelta, label: label, tag: tag, depth: depth);
  }

  void _log(int delta, {required String label, String? tag, int? depth}) {
    final a = GaplyProfiler.theme.ansi;
    final String formatted = GaplyBudget.formatBytes(delta);

    final String color = delta > 0 ? a.jank : a.perf;
    final String indent = (depth ?? 0) > 0 ? '${'  ' * depth!}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    String percentStr = '';
    if (thresholdBytes > 0) {
      final double p = (delta.abs() / thresholdBytes) * 100;
      percentStr = ' ${a.gray}(${p.toStringAsFixed(1)}%)${a.reset}';
    }

    GaplyLogger.i(
      '${a.gray}[MEM]${a.reset} $indent${a.label}$label${a.reset}$tagStr : '
      '$color${formatted.padLeft(10)}${a.reset}$percentStr',
    );
  }

  @override
  void printStats(String label) {
    _statsMap[label]?.printSummary(label);
  }
}

class _MemoryStats {
  int count = 0;
  int totalDelta = 0;
  int peakDelta = 0;
  int minDelta = 0;
  int lastThreshold = 0;

  void add(int delta, int threshold) {
    count++;
    totalDelta += delta;
    lastThreshold = threshold;
    if (delta > peakDelta) peakDelta = delta;
    if (delta < minDelta) minDelta = delta;
  }

  double get avgDelta => totalDelta / count;

  void printSummary(String label) {
    final a = GaplyProfiler.theme.ansi;

    final String avgStr = GaplyBudget.formatBytes((totalDelta / count).toInt());
    final String peakStr = GaplyBudget.formatBytes(peakDelta);
    final String minStr = GaplyBudget.formatBytes(minDelta);
    final String limitStr = GaplyBudget.formatBytes(lastThreshold);

    final bool isOver = lastThreshold > 0 && peakDelta > lastThreshold;
    final String peakColor = isOver ? a.accent : a.label;

    String offsetStr = '';
    if (lastThreshold > 0) {
      final int diff = peakDelta - lastThreshold;
      final String sign = diff > 0 ? '+' : '';
      final String diffColor = diff > 0 ? a.jank : a.gray;
      offsetStr = ' ${a.gray}($diffColor$sign${GaplyBudget.formatBytes(diff)}${a.gray})${a.reset}';
    }

    GaplyLogger.i(
      '🧠 ${a.label}[MEMORY STATS] $label${a.reset} ${a.gray}(Budget: $limitStr)${a.reset}\n'
      '   Calls: $count | '
      'Avg Delta: ${a.label}$avgStr${a.reset} | '
      'Peak: $peakColor$peakStr$offsetStr${a.reset} | '
      'Min: ${a.perf}$minStr${a.reset}',
      isForce: true,
    );
  }
}
