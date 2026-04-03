part of 'gaply_profiler.dart';

/// [GaplyMemoryEngine] - Focused on tracking memory allocation and leaks
class GaplyMemoryEngine extends GaplyProfilerEngine<MemoryStats> {
  static const String categoryName = 'GaplyMemory';

  @override
  final GaplyMemoryEngineSpec spec;

  @override
  String get category => GaplyTraceEngine.categoryName;

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
    final int depth = pkt[ProfilerIdx.depth];
    final int memoryDelta = pkt[ProfilerIdx.memDelta];
    final Map<String, dynamic>? metadata = pkt[ProfilerIdx.metadata];

    final String statsKey = tag != null ? '$labelId@$tag' : labelId;
    final stats = statsMap.putIfAbsent(statsKey, () => MemoryStats(engine: this));
    stats.add(memoryDelta);

    if (memoryDelta.abs() >= spec.thresholdBytes) {
      _log(memoryDelta, label: labelId, tag: tag, depth: depth, metadata: metadata);
    }
  }

  void _log(
    int delta, {
    required String label,
    String? tag,
    required int depth,
    Map<String, dynamic>? metadata,
  }) {
    final a = GaplyHub.theme.ansi;
    final String formatted = GaplyBudget.formatBytes(delta);

    final String icon = delta > 0 ? '📈' : '📉';
    final String color = delta > 0 ? a.jank : a.perf;
    final String indent = depth > 0 ? '${'  ' * depth}└ ' : '';
    final String tagStr = tag != null ? ' ${a.tag}@$tag${a.reset}' : '';

    String metaStr = '';
    if (metadata != null && metadata.isNotEmpty) {
      metaStr = ' ${a.gray}context:$metadata${a.reset}';
    }

    infoLog(
      '${a.gray}[MEM]${a.reset} $indent$icon ${a.label}$label${a.reset}$tagStr : '
      '$color${formatted.padLeft(10)}${a.reset}$metaStr',
    );
  }
}

class MemoryStats implements GaplyProfilerStats {
  final GaplyMemoryEngine engine;

  Map<String, dynamic>? peakMetadata;

  int count = 0;
  int totalDelta = 0;
  int peakDelta = 0;
  int minDelta = 0;
  int lastThresholdBytes = 0;

  @override
  DateTime lastLogTime = DateTime.now();

  @override
  bool get isNotEmpty => count > 0;

  MemoryStats({required this.engine});

  void add(int delta, {Map<String, dynamic>? metadata}) {
    count++;
    totalDelta += delta;
    lastLogTime = DateTime.now();

    if (delta > peakDelta) {
      peakDelta = delta;
      peakMetadata = metadata;
    }
    if (delta < minDelta) minDelta = delta;
  }

  @override
  void printSummary(String label) {
    if (count == 0) return;

    final a = GaplyHub.theme.ansi;

    final String avgStr = GaplyBudget.formatBytes((totalDelta ~/ count));
    final String peakStr = GaplyBudget.formatBytes(peakDelta);
    final String minStr = GaplyBudget.formatBytes(minDelta);
    final String limitStr = GaplyBudget.formatBytes(engine.spec.thresholdBytes);

    final bool isOver = engine.spec.thresholdBytes > 0 && peakDelta > engine.spec.thresholdBytes;
    final String peakColor = isOver ? a.accent : a.label;

    String offsetStr = '';
    if (engine.spec.thresholdBytes > 0) {
      final int diff = peakDelta - engine.spec.thresholdBytes;
      if (diff > 0) {
        offsetStr = ' ${a.gray}(${a.jank}+${GaplyBudget.formatBytes(diff)}${a.gray})${a.reset}';
      }
    }

    String peakHint = '';
    if (peakMetadata != null) {
      peakHint = '\n      ${a.gray}└ Peak Context: $peakMetadata${a.reset}';
    }

    engine.infoLog(
      '🧠 ${a.label}[MEMORY STATS] $label${a.reset} ${a.gray}(Budget: $limitStr)${a.reset}\n'
      '   Calls: $count | '
      'Avg Delta: ${a.label}$avgStr${a.reset} | '
      'Peak: $peakColor$peakStr$offsetStr${a.reset} | '
      'Min: ${a.perf}$minStr${a.reset} | '
      '$peakHint',
      isImmediate: true,
    );
  }

  @override
  void flush() {}

  @override
  Future<void> dispose() async {}
}
