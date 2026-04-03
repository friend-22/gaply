part of 'gaply_profiler.dart';

/// [GaplyMemoryEngine] - Focused on tracking memory allocation and leaks
class GaplyMemoryEngine extends GaplyProfilerEngine<MemoryStats> {
  @override
  String get category => 'Memory';

  @override
  final GaplyMemoryEngineSpec spec;

  GaplyMemoryEngine({required this.spec});

  @override
  void record(dynamic data) {
    final List<dynamic> pkt = data;
    final int memoryDelta = pkt[ProfilerIdx.memDelta];

    if (memoryDelta.abs() < spec.thresholdBytes) return;
    sendPacket(data);
  }

  @override
  void onDataReceived(dynamic data) {
    final List<dynamic> pkt = data;
    final String labelId = pkt[ProfilerIdx.id];
    final String? tag = pkt[ProfilerIdx.tag];
    final int memoryDelta = pkt[ProfilerIdx.memDelta];

    final String statsKey = tag != null ? '$labelId@$tag' : labelId;
    final stats = statsMap.putIfAbsent(statsKey, () => MemoryStats(engine: this, label: labelId, tag: tag));
    stats.add(data);

    if (memoryDelta.abs() >= spec.thresholdBytes) {
      _log(data);
    }
  }

  void _log(dynamic data) {
    final f = GaplyHub.theme.formatter;
    final List<dynamic> pkt = data;
    final int memoryDelta = pkt[ProfilerIdx.memDelta];

    final String icon = memoryDelta > 0 ? '📈' : '📉';
    final String color = memoryDelta > 0 ? f.ansi.jank : f.ansi.perf;
    final String formatted = GaplyBudget.formatBytes(memoryDelta).padLeft(10);

    final header = f.header('MEM', pkt[ProfilerIdx.id], tag: pkt[ProfilerIdx.tag]);
    final indent = f.indent(pkt[ProfilerIdx.depth]);

    infoLog('$header : $indent$icon $color$formatted${f.ansi.reset}');
    //
    // final List<dynamic> pkt = data;
    // final String label = pkt[ProfilerIdx.id];
    // final String? tag = pkt[ProfilerIdx.tag];
    // final int depth = pkt[ProfilerIdx.depth];
    // final int memoryDelta = pkt[ProfilerIdx.memDelta];
    // final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];
    //
    // final a = GaplyHub.theme.ansi;
    // final String formatted = GaplyBudget.formatBytes(memoryDelta);
    //
    // final String icon = memoryDelta > 0 ? '📈' : '📉';
    // final String color = memoryDelta > 0 ? a.jank : a.perf;
    // final String indent = depth > 0 ? '${'  ' * depth}└ ' : '';
    // final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';
    //
    // String metaStr = '';
    // if (metadata != null && metadata.isNotEmpty) {
    //   metaStr = ' ${a.gray}context:$metadata${a.reset}';
    // }
    //
    // infoLog(
    //   '${a.gray}[MEM]${a.reset} $indent$icon ${a.label}$label${a.reset}$tagStr : '
    //       '$color${formatted.padLeft(10)}${a.reset}$metaStr',
    // );
  }
}

class MemoryStats extends GaplyProfilerStats {
  GaplyMemoryEngine get memEngine => engine as GaplyMemoryEngine;

  int count = 0;
  int totalDelta = 0;
  int peakDelta = 0;
  int minDelta = 0;
  int lastThresholdBytes = 0;
  Map<String, dynamic>? _sessionPeakMetadata;

  int errorCount = 0;
  String? _lastError;

  int globalCount = 0;
  int globalTotalDelta = 0;
  int globalPeakDelta = 0;
  int globalErrorCount = 0;
  Map<String, dynamic>? _globalPeakMetadata;

  @override
  bool get isNotEmpty => count > 0;

  MemoryStats({required super.engine, required super.label, super.tag});

  void add(dynamic data) {
    final List<dynamic> pkt = data;
    final int memoryDelta = pkt[ProfilerIdx.memDelta];
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];
    final dynamic error = pkt.length > ProfilerIdx.error ? pkt[ProfilerIdx.error] : null;

    count++;
    globalCount++;
    totalDelta += memoryDelta;
    globalTotalDelta += memoryDelta;

    if (memoryDelta > peakDelta) {
      peakDelta = memoryDelta;
      _sessionPeakMetadata = metadata;
    }

    if (memoryDelta > globalPeakDelta) {
      globalPeakDelta = memoryDelta;
      _globalPeakMetadata = metadata;
    }

    if (memoryDelta < minDelta) minDelta = memoryDelta;

    if (error != null) {
      errorCount++;
      globalErrorCount++;
      _lastError = error.toString();
    }

    checkFlushThreshold(count);
  }

  void _reset() {
    count = 0;
    totalDelta = 0;
    peakDelta = 0;
    minDelta = 0;
    errorCount = 0;
    _lastError = null;
    _sessionPeakMetadata = null;
    lastLogTime = DateTime.now();
  }

  @override
  void flush() {
    if (!isNotEmpty) return;

    final f = GaplyHub.theme.formatter;
    final a = f.ansi;

    final header = f.header('MEM', label, tag: tag);
    final error = f.errorStatus(count, errorCount);

    final String avgStr = GaplyBudget.formatBytes(totalDelta ~/ count);
    final String peakStr = GaplyBudget.formatBytes(peakDelta);

    String peakHint = '';
    if (_sessionPeakMetadata != null && _sessionPeakMetadata!.isNotEmpty) {
      peakHint = '\n           ${a.gray}└ Session Peak Meta: $_sessionPeakMetadata${a.reset}';
    }

    String errorHint = '';
    if (errorCount > 0 && _lastError != null) {
      errorHint = '\n           ${a.error}└ Last Error: $_lastError${a.reset}';
    }

    engine.infoLog(
      '$header : Avg Delta ${a.label}$avgStr${a.reset} | '
      'Peak ${a.accent}$peakStr${a.reset} | '
      'Count: $count$error$peakHint$errorHint',
      isImmediate: true,
    );

    _reset();
  }

  @override
  void printSummary(String label) {
    if (globalCount == 0) return;
    if (isNotEmpty) flush();

    final f = GaplyHub.theme.formatter;
    final a = f.ansi;

    final String avgStr = GaplyBudget.formatBytes(globalTotalDelta ~/ globalCount);
    final String peakStr = GaplyBudget.formatBytes(globalPeakDelta);
    final int limitBytes = memEngine.spec.thresholdBytes;
    final String limitStr = GaplyBudget.formatBytes(limitBytes);

    final bool isOver = limitBytes > 0 && globalPeakDelta > limitBytes;
    final String peakColor = isOver ? a.jank : a.perf;

    String offsetStr = '';
    if (isOver) {
      final int diff = globalPeakDelta - limitBytes;
      offsetStr = ' ${a.gray}(${a.jank}+${GaplyBudget.formatBytes(diff)}${a.gray})${a.reset}';
    }

    String peakHint = '';
    if (_globalPeakMetadata != null && _globalPeakMetadata!.isNotEmpty) {
      peakHint = '\n           ${a.gray}└ Global Peak Context: $_globalPeakMetadata${a.reset}';
    }

    engine.infoLog(
      '${f.header('MEM SUMMARY', label, tag: tag)} ${a.gray}(Budget: $limitStr)${a.reset}\n'
      '           Avg Delta: ${a.label}$avgStr${a.reset} | '
      'Peak: $peakColor$peakStr$offsetStr${a.reset} | '
      'Reliability: ${f.errorStatus(globalCount, globalErrorCount).trim().isEmpty ? "${a.success}100% OK" : f.errorStatus(globalCount, globalErrorCount)}'
      '$peakHint',
      isImmediate: true,
    );
  }
}
