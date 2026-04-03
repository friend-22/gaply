part of 'gaply_profiler.dart';

/// [GaplyTraceEngine] - Immediate logging for individual performance hits
class GaplyTraceEngine extends GaplyProfilerEngine<TraceStats> {
  @override
  String get category => 'Trace';

  @override
  final GaplyTraceEngineSpec spec;

  GaplyTraceEngine({required this.spec});

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

    final stats = statsMap.putIfAbsent(labelId, () => TraceStats(engine: this, label: labelId, tag: tag));
    stats.add(spec.threshold.inMicroseconds, data);

    if (elapsedUs >= spec.threshold.inMicroseconds) {
      _log(data);
    }
  }

  void _log(dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.sw];
    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];
    final int depth = pkt[ProfilerIdx.depth];
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];

    final f = GaplyHub.theme.formatter;
    final a = f.ansi;

    final String timeStr = a.gray + DateTime.now().toString().substring(11, 19) + a.reset;
    final String header = f.header(category.toUpperCase(), labelId, tag: tag);
    final String indent = f.indent(depth);

    final double ms = elapsedUs / 1000;
    final double limit = spec.threshold.inMicroseconds / 1000;

    String metaStr = '';
    if (metadata != null && metadata.isNotEmpty) {
      metaStr = ' ${a.gray}meta:$metadata${a.reset}';
    }

    infoLog(
      '$timeStr $header : $indent${f.formatMs(ms, limit, showDiff: false)}$metaStr',
      isImmediate: false,
    );
  }
}

class TraceStats extends GaplyProfilerStats {
  int syncCount = 0;
  int syncTotalUs = 0;
  int syncMaxUs = 0;
  final List<int> syncDist = [0, 0, 0, 0];
  final Map<String, List<int>> tagDist = {};
  Map<String, dynamic>? _maxSyncMeta;

  int asyncCount = 0;
  int asyncTotalUs = 0;
  int asyncMaxUs = 0;
  Map<String, dynamic>? _maxAsyncMeta;

  int globalSyncCount = 0;
  int globalSyncTotalUs = 0;
  int globalSyncMaxUs = 0;
  final List<int> globalSyncDist = [0, 0, 0, 0];

  int globalAsyncCount = 0;
  int globalAsyncTotalUs = 0;
  int globalAsyncMaxUs = 0;
  Map<String, dynamic>? _globalMaxAsyncMeta;

  int errorCount = 0;
  int globalErrorCount = 0;
  String? _lastError;

  int lastThresholdUs = 0;

  @override
  bool get isNotEmpty => syncCount > 0 || asyncCount > 0;

  TraceStats({required super.engine, required super.label, super.tag});

  int _getDistIdx(int elapsedUs) {
    if (elapsedUs < GaplyBudget.slow.inMicroseconds) return 0;
    if (elapsedUs < GaplyBudget.warning.inMicroseconds) return 1;
    if (elapsedUs < GaplyBudget.critical.inMicroseconds) return 2;
    return 3;
  }

  void add(int thresholdUs, dynamic data) {
    final List<dynamic> pkt = data;
    final int elapsedUs = pkt[ProfilerIdx.sw];
    final String? tag = pkt[ProfilerIdx.tag];
    final bool isAsync = pkt[ProfilerIdx.isAsync] == 1;
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];
    final dynamic error = pkt.length > ProfilerIdx.error ? pkt[ProfilerIdx.error] : null;

    lastThresholdUs = thresholdUs;

    if (isAsync) {
      asyncCount++;
      globalAsyncCount++;
      asyncTotalUs += elapsedUs;
      globalAsyncTotalUs += elapsedUs;

      if (elapsedUs > asyncMaxUs) {
        asyncMaxUs = elapsedUs;
        _maxAsyncMeta = metadata;
      }
      if (elapsedUs > globalAsyncMaxUs) {
        globalAsyncMaxUs = elapsedUs;
        _globalMaxAsyncMeta = metadata;
      }
    } else {
      syncCount++;
      globalSyncCount++;
      syncTotalUs += elapsedUs;
      globalSyncTotalUs += elapsedUs;

      if (elapsedUs > syncMaxUs) {
        syncMaxUs = elapsedUs;
        _maxSyncMeta = metadata;
      }

      int distIdx = _getDistIdx(elapsedUs);
      syncDist[distIdx]++;
      globalSyncDist[distIdx]++;

      if (tag != null) {
        tagDist.putIfAbsent(tag, () => [0, 0, 0, 0])[distIdx]++;
      }
    }

    if (error != null) {
      errorCount++;
      globalErrorCount++;
      _lastError = error.toString();
    }

    checkFlushThreshold(syncCount + asyncCount);
  }

  void _reset() {
    syncCount = 0;
    syncTotalUs = 0;
    syncMaxUs = 0;
    syncDist.fillRange(0, syncDist.length, 0);
    tagDist.clear();
    _maxSyncMeta = null;

    asyncCount = 0;
    asyncTotalUs = 0;
    asyncMaxUs = 0;
    _maxAsyncMeta = null;

    errorCount = 0;
    _lastError = null;
    lastLogTime = DateTime.now();
  }

  @override
  void flush() {
    if (!isNotEmpty) return;

    final f = GaplyHub.theme.formatter;
    final header = f.header('TRACE', label, tag: tag);
    final error = f.errorStatus(syncCount + asyncCount, errorCount);

    String errorHint = '';
    if (errorCount > 0 && _lastError != null) {
      errorHint = '\n           ${f.ansi.error}└ Last Error: $_lastError${f.ansi.reset}';
    }

    String syncMetaHint = '';
    if (_maxSyncMeta != null && _maxSyncMeta!.isNotEmpty) {
      syncMetaHint = '\n           ${f.ansi.gray}└ Session Sync Max: $_maxSyncMeta${f.ansi.reset}';
    }

    String asyncMetaHint = '';
    if (_maxAsyncMeta != null && _maxAsyncMeta!.isNotEmpty) {
      asyncMetaHint = '\n           ${f.ansi.gray}└ Session Async Max: $_maxAsyncMeta${f.ansi.reset}';
    }

    engine.infoLog(
      '$header : Sync($syncCount) Async($asyncCount) $error'
      '$syncMetaHint'
      '$asyncMetaHint'
      '$errorHint',
      isImmediate: true,
    );

    _reset();
  }

  @override
  void printSummary(String label) {
    if (globalSyncCount == 0 && globalAsyncCount == 0) return;
    if (isNotEmpty) flush();

    final f = GaplyHub.theme.formatter;
    final double limit = lastThresholdUs / 1000;

    engine.infoLog(f.header('TRACE SUMMARY', label, tag: tag), isImmediate: true);
    engine.infoLog(
      ' 🎯 ${f.ansi.hint}${GaplyBudget.syncThresholdGuide}${f.ansi.reset} 🎯',
      isImmediate: true,
    );

    if (globalSyncCount > 0) {
      final double avgMs = (globalSyncTotalUs / globalSyncCount) / 1000;
      engine.infoLog(
        '   ${f.ansi.label}[Sync]${f.ansi.reset}  Avg:${f.formatMs(avgMs, limit)} | Count:$globalSyncCount',
        isImmediate: true,
      );
      engine.infoLog(
        '           Dist: ${f.formatDistRow(globalSyncDist, globalSyncCount)}',
        isImmediate: true,
      );

      if (_maxSyncMeta != null) {
        engine.infoLog(
          '           ${f.ansi.gray}└ Peak Sync Meta: $_maxSyncMeta${f.ansi.reset}',
          isImmediate: true,
        );
      }
    }

    if (globalAsyncCount > 0) {
      final double avgMs = (globalAsyncTotalUs / globalAsyncCount) / 1000;
      final double maxMs = globalAsyncMaxUs / 1000;

      engine.infoLog(
        '   ${f.ansi.async}[Async]${f.ansi.reset} Avg:${f.formatMs(avgMs, limit)} | Max:${f.ansi.accent}${maxMs.toStringAsFixed(3)}ms${f.ansi.reset}',
        isImmediate: true,
      );

      if (_globalMaxAsyncMeta != null && _globalMaxAsyncMeta!.isNotEmpty) {
        engine.infoLog(
          '           ${f.ansi.gray}└ Peak Async Meta: $_globalMaxAsyncMeta${f.ansi.reset}',
          isImmediate: true,
        );
      }
    }

    if (globalErrorCount > 0) {
      engine.infoLog(
        '   ${f.ansi.error}[Error]${f.ansi.reset} Total Failures: $globalErrorCount',
        isImmediate: true,
      );
    }
  }
}
