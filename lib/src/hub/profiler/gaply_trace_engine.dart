part of 'gaply_profiler.dart';

/// [GaplyTraceEngine] - Immediate logging for individual performance hits
class GaplyTraceEngine extends GaplyProfilerEngine<TraceStats> {
  static const String categoryName = 'GaplyTrace';

  @override
  final GaplyTraceEngineSpec spec;

  @override
  String get category => GaplyTraceEngine.categoryName;

  GaplyTraceEngine({required this.spec});

  @override
  void record(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.us];

    if (elapsedUs < spec.threshold.inMicroseconds) return;

    sendPacket(data);
  }

  @override
  void onDataReceived(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.us];
    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];
    final bool isAsync = pkt[ProfilerIdx.isAsync] == 1;

    final stats = statsMap.putIfAbsent(labelId, () => TraceStats(engine: this));

    stats.add(elapsedUs, isAsync, tag, spec.threshold.inMicroseconds);

    if (elapsedUs >= spec.threshold.inMicroseconds) {
      _log(data);
    }
  }

  void _log(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.us];
    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];
    final int depth = pkt[ProfilerIdx.depth];

    final double ms = elapsedUs / 1000;
    final double limit = spec.threshold.inMicroseconds / 1000;

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final String indent = depth > 0 ? '${'  ' * depth}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    infoLog(
      '${a.gray}[${DateTime.now().toString().substring(11, 19)}]${a.reset} '
      '$indent$labelId$tagStr : ${fmt.formatMs(ms, limit)}',
      isImmediate: false,
    );
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

  Timer? _autoFlushTimer;

  TraceStats({required this.engine}) {
    _autoFlushTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (isNotEmpty) flush();
    });
  }

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
    if (!isNotEmpty) return;

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final double limit = lastThresholdUs / 1000;

    engine.infoLog(
      '📊 ${a.label}[STATS] $label${a.reset} ${a.gray}(Threshold: ${limit.toStringAsFixed(2)}ms)${a.reset}',
      isImmediate: true,
    );

    engine.infoLog(' 🎯 ${a.hint}${GaplyBudget.syncThresholdGuide} 🎯', isImmediate: true);

    if (syncCount > 0) {
      final double avgMs = (syncTotalUs / syncCount) / 1000;
      final double maxMs = syncMaxUs / 1000;

      engine.infoLog(
        '   ${a.label}[Sync]${a.reset}  Total:$syncCount | '
        'Avg:${fmt.formatMs(avgMs, limit)} | '
        'Max:${fmt.formatMs(maxMs, limit)}',
        isImmediate: true,
      );
      engine.infoLog('           Total Dist: ${fmt.formatDistRow(syncDist, syncCount)}', isImmediate: true);

      tagDist.forEach((tag, dist) {
        int tagTotal = dist.reduce((a, b) => a + b);
        engine.infoLog(
          '           ${a.gray}└${a.reset} ${a.tag}@$tag${a.reset}: ${fmt.formatDistRow(dist, tagTotal)}',
          isImmediate: true,
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
        isImmediate: true,
      );
    }
  }

  @override
  void flush() {
    if (!isNotEmpty) return;

    printSummary("${engine.spec.id} (Auto-Flush)");

    _reset();
    lastLogTime = DateTime.now();
  }

  void _reset() {
    syncCount = 0;
    syncTotalUs = 0;
    syncMaxUs = 0;
    syncDist.fillRange(0, syncDist.length, 0);
    tagDist.clear();
    asyncCount = 0;
    asyncTotalUs = 0;
    asyncMaxUs = 0;
  }

  @override
  Future<void> dispose() async {
    _autoFlushTimer?.cancel();
    _autoFlushTimer = null;
    if (isNotEmpty) flush();
  }
}
