import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'gaply_profiler_base.dart';
import 'gaply_profiler_mixin.dart';

/// [GaplyTraceEngine] - Immediate logging for individual performance hits
class GaplyTraceEngine extends GaplyProfilerEngine with GaplyProfilerMixin<TraceStats> {
  final Duration threshold;
  @override
  String get category => 'Trace';
  @override
  final int maxKeys;
  @override
  final Duration maxIdleTime;
  @override
  Map<String, TraceStats> get statsMap => _statsMap;

  static final Map<String, TraceStats> _statsMap = {};

  GaplyTraceEngine({
    super.customLogger,
    this.threshold = GaplyBudget.smooth60,
    this.maxKeys = 500,
    this.maxIdleTime = const Duration(minutes: 5),
  }) {
    initMasterListener((packet) {
      final stats = statsMap.putIfAbsent(packet.label, () => TraceStats(engine: this));

      stats.add(packet.elapsed.inMicroseconds, packet.isAsync, packet.tag, threshold.inMicroseconds);

      if (packet.elapsed >= threshold) {
        _log(packet);
      }
    });
  }

  @override
  void record(ProfilePacket packet) {
    sendPacket(packet);
  }

  void _log(ProfilePacket packet) {
    final double ms = packet.elapsed.inMicroseconds / 1000;
    final double limit = threshold.inMicroseconds / 1000;

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final String indent = packet.depth > 0 ? '${'  ' * packet.depth}└ ' : '';
    final String tagStr = packet.tag != null ? ' ${a.tag}@$packet.tag${a.reset}' : '';

    infoLog(
      '${a.gray}[${DateTime.now().toString().substring(11, 19)}]${a.reset} '
      '$indent$packet.label$tagStr : ${fmt.formatMs(ms, limit)}',
      isForce: false,
    );
  }

  @override
  void printStats(String label) {
    _statsMap[label]?.printSummary(label);
  }
}

class TraceStats implements GaplyProfilerStats {
  final GaplyTraceEngine engine;

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

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => syncCount > 0 || asyncCount > 0;

  TraceStats({required this.engine});

  void add(int us, bool isAsync, String? tag, int thresholdUs) {
    lastThresholdUs = thresholdUs;
    lastLogTime = DateTime.now();

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

  @override
  void printSummary(String label) {
    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final double limit = lastThresholdUs / 1000;

    engine.infoLog(
      '📊 ${a.label}[STATS] $label${a.reset} ${a.gray}(Threshold: ${limit.toStringAsFixed(2)}ms)${a.reset}',
      isForce: true,
    );

    engine.infoLog(' 🎯 ${a.hint}${GaplyBudget.syncThresholdGuide} 🎯', isForce: true);

    if (syncCount > 0) {
      final double avgMs = (syncTotalUs / syncCount) / 1000;
      final double maxMs = syncMaxUs / 1000;

      engine.infoLog(
        '   ${a.label}[Sync]${a.reset}  Total:$syncCount | '
        'Avg:${fmt.formatMs(avgMs, limit)} | '
        'Max:${fmt.formatMs(maxMs, limit)}',
        isForce: true,
      );

      engine.infoLog('           Total Dist: ${fmt.formatDistRow(syncDist, syncCount)}', isForce: true);

      tagDist.forEach((tag, dist) {
        int tagTotal = dist.reduce((a, b) => a + b);
        engine.infoLog(
          '           ${a.gray}└${a.reset} ${a.tag}@$tag${a.reset}: ${fmt.formatDistRow(dist, tagTotal)}',
          isForce: true,
        );
      });
    }

    if (asyncCount > 0) {
      final double avg = (asyncTotalUs / asyncCount) / 1000;
      final double max = asyncMaxUs / 1000;
      engine.infoLog(
        '   ${a.async}[Async]${a.reset} Calls:$asyncCount | '
        'Avg:${a.async}${avg.toStringAsFixed(2)}ms${a.reset} | '
        'Max:${max.toStringAsFixed(2)}ms (Latency)',
        isForce: true,
      );
    }
  }

  @override
  void flush() {}
}
