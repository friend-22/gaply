import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'gaply_profiler_base.dart';
import 'gaply_profiler_mixin.dart';

/// [GaplyBatchEngine] - Collects data and flushes summaries periodically
class GaplyBatchEngine extends GaplyProfilerEngine with GaplyProfilerMixin<BatchCollector> {
  final Duration threshold;
  @override
  String get category => 'Batch';
  @override
  final Map<String, BatchCollector> statsMap = {};
  @override
  final int maxKeys;
  @override
  final Duration maxIdleTime;

  final Duration maxBatchInterval;
  final int maxBatchCount;

  GaplyBatchEngine({
    super.customLogger,
    this.threshold = GaplyBudget.all,
    this.maxBatchInterval = GaplyBudget.fps60,
    this.maxBatchCount = 100,
    this.maxKeys = 500,
    this.maxIdleTime = const Duration(minutes: 5),
  }) {
    initMasterListener((packet) {
      final key = "${packet.label}${packet.tag != null ? '_${packet.tag}' : ''}";
      statsMap
          .putIfAbsent(
            key,
            () => BatchCollector(
              engine: this,
              label: packet.label,
              tag: packet.tag,
              maxInterval: maxBatchInterval,
              maxCount: maxBatchCount,
              threshold: threshold,
            ),
          )
          .add(packet.elapsed.inMicroseconds);
    });
  }

  @override
  void record(ProfilePacket packet) {
    if (packet.elapsed < threshold) return;
    sendPacket(packet);
  }
}

class BatchCollector implements GaplyProfilerStats {
  final GaplyBatchEngine engine;
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

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => count > 0;

  BatchCollector({
    required this.engine,
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
      flush();
    }
  }

  @override
  void flush() {
    if (count == 0) return;

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final double avgMs = (totalUs / count) / 1000;
    final double totalMs = totalUs / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';
    final String percentStr = limit > 0
        ? '${a.gray}(${(avgMs / limit * 100).toStringAsFixed(1)}%)${a.reset}'
        : '';

    engine.infoLog(
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

  @override
  void printSummary(String label) {
    if (globalCount == 0) return;

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final double avgMs = (globalTotalUs / globalCount) / 1000;
    final double maxMs = maxSingleUs / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    engine.infoLog(
      '${a.gray}📦 [BATCH SUMMARY]${a.reset} ${a.label}$label$tagStr${a.reset}\n'
      '           Avg: ${fmt.formatMs(avgMs, limit)} | '
      'Max: ${a.accent}${maxMs.toStringAsFixed(3).padLeft(7)}ms${a.reset} | '
      'Total Calls: ${a.label}$globalCount${a.reset}',
      isForce: true,
    );
  }
}
