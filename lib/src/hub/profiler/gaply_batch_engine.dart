part of 'gaply_profiler.dart';

/// [GaplyBatchEngine] - Collects data and flushes summaries periodically
class GaplyBatchEngine extends GaplyProfilerEngine<BatchCollector> {
  static const String categoryName = 'GaplyBatch';

  @override
  final GaplyBatchEngineSpec spec;

  @override
  String get category => GaplyTraceEngine.categoryName;

  GaplyBatchEngine({required this.spec});

  @override
  void record(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.sw];

    if (elapsedUs < spec.threshold.inMicroseconds) return;
    sendPacket(data);
  }

  @override
  void onDataReceived(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.sw];
    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];

    final key = "$labelId${tag != null ? '_$tag' : ''}";
    statsMap
        .putIfAbsent(key, () => BatchCollector(engine: this, label: labelId, tag: tag))
        .add(elapsedUs, metadata: metadata);
  }
}

class BatchCollector implements GaplyProfilerStats {
  final GaplyBatchEngine engine;
  final String label;
  final String? tag;

  Map<String, dynamic>? _lastMetadata;

  int totalUs = 0;
  int count = 0;

  int globalTotalUs = 0;
  int globalCount = 0;
  int maxSingleUs = 0;

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => count > 0;

  Timer? _autoFlushTimer;

  BatchCollector({required this.engine, required this.label, this.tag}) {
    _autoFlushTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (isNotEmpty) flush();
    });
  }

  void add(int us, {Map<String, dynamic>? metadata}) {
    totalUs += us;
    count++;

    globalTotalUs += us;
    globalCount++;
    if (us > maxSingleUs) maxSingleUs = us;

    if (metadata != null) {
      _lastMetadata = metadata;
    }

    final now = DateTime.now();
    final bool isTimeOut = now.difference(lastLogTime) >= engine.spec.maxBatchInterval;
    final bool isCountOver = count >= engine.spec.maxBatchCount;

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
    final double limit = engine.spec.threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    String metaStr = '';
    if (_lastMetadata != null && _lastMetadata!.isNotEmpty) {
      metaStr = ' ${a.gray}meta:$_lastMetadata${a.reset}';
    }

    final String percentStr = limit > 0
        ? ' ${a.gray}(${(avgMs / limit * 100).toStringAsFixed(1)}%)${a.reset}'
        : '';

    engine.infoLog(
      '${a.gray}📦 [BATCH]${a.reset} ${a.label}$label$tagStr${a.reset} : '
      'Avg ${fmt.formatMs(avgMs, limit)} | '
      'Total ${a.label}${totalMs.toStringAsFixed(3).padLeft(7)}ms${a.reset} | '
      '$percentStr ${a.gray}($count calls)${a.reset}$metaStr',
      isImmediate: true,
    );

    // 초기화 및 시간 갱신
    totalUs = 0;
    count = 0;
    _lastMetadata = null;
    lastLogTime = DateTime.now();
  }

  @override
  void printSummary(String label) {
    if (globalCount == 0) return;

    if (isNotEmpty) {
      flush();
    }

    final a = GaplyHub.theme.ansi;
    final fmt = GaplyHub.theme.formatter;

    final double avgMs = (globalTotalUs / globalCount) / 1000;
    final double maxMs = maxSingleUs / 1000;
    final double limit = engine.spec.threshold.inMicroseconds / 1000;

    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    engine.infoLog(
      '${a.gray}📦 [BATCH SUMMARY]${a.reset} ${a.label}$label$tagStr${a.reset}\n'
      '           Avg: ${fmt.formatMs(avgMs, limit)} | '
      'Max: ${a.accent}${maxMs.toStringAsFixed(3).padLeft(7)}ms${a.reset} | '
      'Total Calls: ${a.label}$globalCount${a.reset}',
      isImmediate: true,
    );
  }

  @override
  Future<void> dispose() async {
    _autoFlushTimer?.cancel();
    _autoFlushTimer = null;

    if (isNotEmpty) {
      flush();
    }
  }
}
