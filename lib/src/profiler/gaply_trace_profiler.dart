import 'gaply_budget.dart';
import 'gaply_profiler.dart';
import 'gaply_logger.dart';

/// [GaplyTraceEngine] - Immediate logging for individual performance hits
class GaplyTraceEngine implements GaplyProfileEngine {
  final Duration threshold;

  static final Map<String, _ProfilerStats> _statsMap = {};

  const GaplyTraceEngine({this.threshold = GaplyBudget.smooth60});

  @override
  void record(
    Duration elapsed, {
    required int memoryDelta,
    required String label,
    String? tag,
    int? depth,
    bool isAsync = false,
  }) {
    _statsMap
        .putIfAbsent(label, () => _ProfilerStats())
        .add(elapsed.inMicroseconds, isAsync, tag, threshold.inMicroseconds);

    if (elapsed < threshold) return;

    _log(elapsed, label: label, tag: tag, depth: depth, isAsync: isAsync);
  }

  void _log(Duration elapsed, {required String label, String? tag, int? depth, bool isAsync = false}) {
    final double ms = elapsed.inMicroseconds / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final a = GaplyProfiler.theme.ansi;
    final fmt = GaplyProfiler.theme.formatter;

    final String indent = depth != null && depth > 0 ? '${'  ' * depth}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    GaplyLogger.i(
      '${a.gray}[${DateTime.now().toString().substring(11, 19)}]${a.reset} '
      '$indent$label$tagStr : ${fmt.formatMs(ms, limit)}',
      isForce: false,
    );
  }

  @override
  void printStats(String label) {
    _statsMap[label]?.printSummary(label);
  }
}

class _ProfilerStats {
  int syncCount = 0;
  int syncTotalUs = 0;
  int syncMaxUs = 0;
  int lastThresholdUs = 0;

  // Buckets: [Perfect, Normal, Warning, Critical/Jank]
  final List<int> syncDist = [0, 0, 0, 0];
  final Map<String, List<int>> tagDist = {};

  int asyncCount = 0;
  int asyncTotalUs = 0;
  int asyncMaxUs = 0;

  void add(int us, bool isAsync, String? tag, int thresholdUs) {
    lastThresholdUs = thresholdUs;

    if (isAsync) {
      asyncCount++;
      asyncTotalUs += us;
      if (us > asyncMaxUs) asyncMaxUs = us;
    } else {
      syncCount++;
      syncTotalUs += us;
      if (us > syncMaxUs) syncMaxUs = us;

      int distIdx;
      if (us < GaplyBudget.slow.inMicroseconds) {
        distIdx = 0;
      } else if (us < GaplyBudget.warning.inMicroseconds) {
        distIdx = 1;
      } else if (us < GaplyBudget.critical.inMicroseconds) {
        distIdx = 2;
      } else {
        distIdx = 3;
      }

      syncDist[distIdx]++;

      if (tag != null) {
        tagDist.putIfAbsent(tag, () => [0, 0, 0, 0])[distIdx]++;
      }
    }
  }

  void printSummary(String label) {
    final a = GaplyProfiler.theme.ansi;
    final fmt = GaplyProfiler.theme.formatter;

    final double limit = lastThresholdUs / 1000;

    GaplyLogger.i(
      '📊 ${a.label}[STATS] $label${a.reset} ${a.gray}(Threshold: ${limit.toStringAsFixed(2)}ms)${a.reset}',
      isForce: true,
    );
    GaplyLogger.i(' 🎯 ${a.hint}${GaplyBudget.syncThresholdGuide} 🎯', isForce: true);

    if (syncCount > 0) {
      final double avgMs = (syncTotalUs / syncCount) / 1000;
      final double maxMs = syncMaxUs / 1000;

      GaplyLogger.i(
        '   ${a.label}[Sync]${a.reset}  Total:$syncCount | '
        'Avg:${fmt.formatMs(avgMs, limit)} | '
        'Max:${fmt.formatMs(maxMs, limit)}',
        isForce: true,
      );

      GaplyLogger.i('           Total Dist: ${fmt.formatDistRow(syncDist, syncCount)}', isForce: true);

      tagDist.forEach((tag, dist) {
        int tagTotal = dist.reduce((a, b) => a + b);
        GaplyLogger.i(
          '           ${a.gray}└${a.reset} ${a.tag}@$tag${a.reset}: ${fmt.formatDistRow(dist, tagTotal)}',
          isForce: true,
        );
      });
    }

    if (asyncCount > 0) {
      final double avg = (asyncTotalUs / asyncCount) / 1000;
      final double max = asyncMaxUs / 1000;
      GaplyLogger.i(
        '   ${a.async}[Async]${a.reset} Calls:$asyncCount | '
        'Avg:${a.async}${avg.toStringAsFixed(2)}ms${a.reset} | '
        'Max:${max.toStringAsFixed(2)}ms (Latency)',
        isForce: true,
      );
    }
  }
}
