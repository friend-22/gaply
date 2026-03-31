import 'gaply_budget.dart';
import 'gaply_profiler.dart';
import 'gaply_logger.dart';

/// [GaplyBatchEngine] - Collects data and flushes summaries periodically
class GaplyBatchEngine implements GaplyProfileEngine {
  final Duration threshold;
  final Duration maxBatchInterval;
  final int maxBatchCount;

  final Map<String, _BatchCollector> _batchMap = {};

  GaplyBatchEngine({
    this.threshold = GaplyBudget.all,
    this.maxBatchInterval = GaplyBudget.fps60,
    this.maxBatchCount = 100,
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
    if (elapsed < threshold) return;

    final key = "$label${tag != null ? '_$tag' : ''}";

    _batchMap
        .putIfAbsent(
          key,
          () => _BatchCollector(
            label: label,
            tag: tag,
            maxInterval: maxBatchInterval,
            maxCount: maxBatchCount,
            threshold: threshold,
          ),
        )
        .add(elapsed.inMicroseconds);
  }

  @override
  void printStats(String label) {
    for (var entry in _batchMap.entries) {
      if (entry.key.startsWith(label)) {
        entry.value.printSummary();
      }
    }
  }
}

class _BatchCollector {
  final String label;
  final String? tag;
  final Duration maxInterval;
  final int maxCount;
  final Duration threshold;

  int totalUs = 0;
  int count = 0;

  int globalTotalUs = 0;
  int globalCount = 0;
  int maxSingleUs = 0;

  DateTime lastLogTime = DateTime.now();

  _BatchCollector({
    required this.label,
    this.tag,
    required this.maxInterval,
    required this.maxCount,
    required this.threshold,
  });

  void add(int us) {
    totalUs += us;
    count++;

    globalTotalUs += us;
    globalCount++;
    if (us > maxSingleUs) maxSingleUs = us;

    final now = DateTime.now();
    final bool isTimeOut = now.difference(lastLogTime) > maxInterval;
    final bool isCountOver = count >= maxCount;
    if (isTimeOut || isCountOver) {
      _flush();
    }
  }

  void _flush() {
    if (count == 0) return;

    final a = GaplyProfiler.theme.ansi;
    final fmt = GaplyProfiler.theme.formatter;

    final double avgMs = (totalUs / count) / 1000;
    final double totalMs = totalUs / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';
    final String percentStr = limit > 0
        ? '${a.gray}(${(avgMs / limit * 100).toStringAsFixed(1)}%)${a.reset}'
        : '';

    GaplyLogger.i(
      '${a.gray}📦 [BATCH]${a.reset} ${a.label}$label$tagStr${a.reset} : '
      'Avg ${fmt.formatMs(avgMs, limit)} | '
      'Total ${a.label}${totalMs.toStringAsFixed(3).padLeft(7)}ms${a.reset} | '
      '$percentStr ${a.gray}($count calls)${a.reset}',
      isForce: true,
    );

    totalUs = 0;
    count = 0;
    lastLogTime = DateTime.now();
  }

  void printSummary() {
    if (globalCount == 0) return;

    final a = GaplyProfiler.theme.ansi;
    final fmt = GaplyProfiler.theme.formatter;

    final double avgMs = (globalTotalUs / globalCount) / 1000;
    final double maxMs = maxSingleUs / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    GaplyLogger.i(
      '${a.gray}📦 [BATCH SUMMARY]${a.reset} ${a.label}$label$tagStr${a.reset}\n'
      '           Avg: ${fmt.formatMs(avgMs, limit)} | '
      'Max: ${a.accent}${maxMs.toStringAsFixed(3).padLeft(7)}ms${a.reset} | '
      'Total Calls: ${a.label}$globalCount${a.reset}',
      isForce: true,
    );
  }
}
