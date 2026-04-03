part of 'gaply_profiler.dart';

/// [GaplyBatchEngine] - Collects data and flushes summaries periodically
class GaplyBatchEngine extends GaplyProfilerEngine<BatchStats> {
  @override
  String get category => 'Batch';

  @override
  final GaplyBatchEngineSpec spec;

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

    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];

    final key = "$labelId${tag != null ? '_$tag' : ''}";
    statsMap.putIfAbsent(key, () => BatchStats(engine: this, label: labelId, tag: tag)).add(data);
  }
}

class BatchStats extends GaplyProfilerStats {
  Map<String, dynamic>? _lastMetadata;

  int totalUs = 0;
  int count = 0;
  int globalTotalUs = 0;
  int globalCount = 0;
  int maxSingleUs = 0;

  int errorCount = 0;
  int globalErrorCount = 0;
  String? _lastError;

  @override
  bool get isNotEmpty => count > 0;

  BatchStats({required super.engine, required super.label, super.tag});

  void add(dynamic data) {
    final List<dynamic> pkt = data;
    final int us = pkt[ProfilerIdx.sw];
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];
    final dynamic error = pkt.length > ProfilerIdx.error ? pkt[ProfilerIdx.error] : null;

    totalUs += us;
    count++;

    globalTotalUs += us;
    globalCount++;

    if (error != null) {
      errorCount++;
      globalErrorCount++;
      _lastError = error.toString();
    }

    if (us > maxSingleUs) maxSingleUs = us;
    if (metadata != null) _lastMetadata = metadata;

    checkFlushThreshold(count);
  }

  void _reset() {
    count = 0;
    totalUs = 0;
    errorCount = 0;
    _lastError = null;
    _lastMetadata = null;
    lastLogTime = DateTime.now();
  }

  @override
  void flush() {
    if (!isNotEmpty) return;

    final f = GaplyHub.theme.formatter;
    final double avgMs = (totalUs / count) / 1000;
    final double limit = engine.spec.threshold.inMicroseconds / 1000;

    final header = f.header('BATCH', label, tag: tag);
    final error = f.errorStatus(count, errorCount);

    String metaStr = '';
    if (_lastMetadata != null && _lastMetadata!.isNotEmpty) {
      metaStr = ' ${f.ansi.gray}meta:$_lastMetadata${f.ansi.reset}';
    }

    String errorHint = '';
    if (errorCount > 0 && _lastError != null) {
      errorHint = ' ${f.ansi.error}└ Last Error: $_lastError${f.ansi.reset}';
    }

    engine.infoLog(
      '$header : Avg ${f.formatMs(avgMs, limit)} | '
      '${f.ansi.label}Count: $count${f.ansi.reset}$error$metaStr'
      '${errorHint.isNotEmpty ? '\n           $errorHint' : ''}',
      isImmediate: true,
    );

    _reset();
  }

  @override
  void printSummary(String label) {
    if (globalCount == 0) return;
    if (isNotEmpty) flush();

    final f = GaplyHub.theme.formatter;
    final double avgMs = (globalTotalUs / globalCount) / 1000;
    final double maxMs = maxSingleUs / 1000;
    final double limit = engine.spec.threshold.inMicroseconds / 1000;

    engine.infoLog(
      '${f.header('BATCH SUMMARY', label, tag: tag)}\n'
      '           Avg: ${f.formatMs(avgMs, limit)} | '
      'Max: ${f.ansi.accent}${maxMs.toStringAsFixed(3).padLeft(7)}ms${f.ansi.reset} | '
      'Reliability: ${f.errorStatus(globalCount, globalErrorCount).trim().isEmpty ? "${f.ansi.success}100% OK" : f.errorStatus(globalCount, globalErrorCount)}',
      isImmediate: true,
    );
  }
}
