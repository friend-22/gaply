import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'gaply_logger.dart';

enum GaplyProfilerFilter {
  critical, // 16.6ms 초과 (60fps 기준 프레임 드랍 발생)
  warning, // 8.3ms 초과 (120fps 기준 프레임 드랍 또는 위험 수준)
  slow, // 1ms 초과
  all, // 모든 측정값 출력
}

extension GaplyTimeExtension on int {
  int get us => this;
  int get ms => this * 1000;
}

class GaplyProfiler {
  final String label;
  final bool enabled;
  final int thresholdUs;
  final GaplyProfilerFilter filter;

  static const Object _depthKey = #gaply_profiler_depth;
  static final Map<String, _ProfilerStats> _statsMap = {};
  static final Map<String, _BatchCollector> _batchMap = {};

  static const int budgetPerfect = 0; // 모든 실행 기록
  static const int budgetNano = 100; // 0.1ms (극도로 예민한 로직)
  static const int budget240Hz = 250; // 0.25ms (240fps 타겟)
  static const int budget120Hz = 500; // 0.5ms (120fps 타겟)
  static const int budget60Hz = 1000; // 1.0ms (60fps 타겟)

  const GaplyProfiler({
    required this.label,
    this.enabled = false,
    this.thresholdUs = budget120Hz,
    this.filter = GaplyProfilerFilter.warning,
  });

  int get _currentDepth => Zone.current[_depthKey] as int? ?? 0;

  const GaplyProfiler.none()
    : label = 'none',
      enabled = false,
      thresholdUs = 0,
      filter = GaplyProfilerFilter.critical;

  const GaplyProfiler.trace({
    required this.label,
    this.thresholdUs = budget120Hz,
    this.filter = GaplyProfilerFilter.warning,
  }) : enabled = true;

  const GaplyProfiler.perfect({required String label, GaplyProfilerFilter filter = GaplyProfilerFilter.all})
    : this(label: label, enabled: true, thresholdUs: budgetPerfect, filter: filter);

  static void clearAllStats() => _statsMap.clear();

  void printStats() {
    for (var entry in _statsMap.entries) {
      entry.value.printSummary(entry.key);
    }

    for (var collector in _batchMap.values) {
      if (collector.count > 0) collector._flush();
    }
  }

  T trace<T>(T Function() operation, {String? tag}) {
    if (!enabled || !kDebugMode) return operation();

    return runZoned(() {
      final sw = Stopwatch()..start();

      try {
        final result = operation();

        if (result is Future) {
          return result.whenComplete(() {
                sw.stop();
                _recordAndLog(sw.elapsedMicroseconds, tag: tag, isAsync: true);
              })
              as T;
        }

        sw.stop();
        _recordAndLog(sw.elapsedMicroseconds, tag: tag);
        return result;
      } catch (e) {
        sw.stop();
        GaplyLogger.i('❌ [ERROR] $label: $e', isForce: true);
        rethrow;
      }
    }, zoneValues: {_depthKey: _currentDepth + 1});
  }

  Future<T> traceAsync<T>(Future<T> Function() operation, {String? tag}) async {
    return trace(() => operation(), tag: tag);
  }

  T traceBatch<T>(T Function() operation, {String? tag}) {
    if (!enabled || !kDebugMode) return operation();

    final sw = Stopwatch()..start();

    try {
      final T result = operation();

      if (result is Future) {
        return result.whenComplete(() {
              sw.stop();
              _recordBatch(sw.elapsedMicroseconds, tag);
            })
            as T;
      }

      sw.stop();
      _recordBatch(sw.elapsedMicroseconds, tag);
      return result;
    } catch (e) {
      sw.stop();

      rethrow;
    }
  }

  Future<T> traceBatchAsync<T>(Future<T> Function() operation, {String? tag}) async {
    return traceBatch(() => operation(), tag: tag);
  }

  void _recordAndLog(int us, {String? tag, bool isAsync = false}) {
    _statsMap.putIfAbsent(label, () => _ProfilerStats()).add(us);
    _log(us, tag: tag, isAsync: isAsync);
  }

  void _recordBatch(int us, String? tag) {
    final key = "$label${tag != null ? '_$tag' : ''}";
    _batchMap.putIfAbsent(key, () => _BatchCollector(label, tag)).add(us);
  }

  void _log(int us, {String? tag, bool isAsync = false}) {
    int effectiveThresholdUs;
    switch (filter) {
      case GaplyProfilerFilter.critical:
        effectiveThresholdUs = 16666;
        break; // 16.6ms (60fps)
      case GaplyProfilerFilter.warning:
        effectiveThresholdUs = 8333;
        break; // 8.3ms (120fps)
      case GaplyProfilerFilter.slow:
        effectiveThresholdUs = 1000;
        break; // 1ms
      case GaplyProfilerFilter.all:
        effectiveThresholdUs = 0;
        break; // 전부
    }

    if (us < effectiveThresholdUs) return;

    final double ms = us / 1000;
    const double frameBudgetMs = 16.66;
    final double frameOccupancy = (ms / frameBudgetMs * 100);

    final int depth = _currentDepth;
    final String indent = depth > 1 ? '${'  ' * (depth - 1)}└ ' : '';

    String color = (ms > 16.66) ? '\x1B[31m' : (ms > 8.3 ? '\x1B[33m' : '\x1B[32m');
    if (isAsync) color = ms > 500 ? '\x1B[31m' : '\x1B[34m';

    final gray = '\x1B[90m';
    final reset = '\x1B[0m';

    final String tagStr = tag != null ? ' $gray@$tag$reset' : '';

    GaplyLogger.i(
      '$gray[${DateTime.now().toString().substring(11, 19)}]$reset '
      '$indent$label$tagStr : $color${ms.toStringAsFixed(3).padLeft(7)}ms$reset '
      '$gray(${frameOccupancy.toStringAsFixed(1)}%)$reset',
      isForce: false,
    );
  }
}

class _ProfilerStats {
  int count = 0;
  int totalUs = 0;
  int maxUs = 0;
  int minUs = 999999;

  final List<int> distribution = [0, 0, 0, 0];

  double get avgMs => (totalUs / count) / 1000;
  double get maxMs => maxUs / 1000;

  void add(int us) {
    count++;
    totalUs += us;
    if (us > maxUs) maxUs = us;
    if (us < minUs) minUs = us;

    if (us < 1000) {
      distribution[0]++;
    } else if (us < 8333) {
      distribution[1]++;
    } else if (us < 16666) {
      distribution[2]++;
    } else {
      distribution[3]++;
    }
  }

  void printSummary(String label) {
    GaplyLogger.i(
      '📊 [$label] Calls:$count | Avg:${avgMs.toStringAsFixed(2)}ms | Max:${maxMs.toStringAsFixed(2)}ms\n'
      '   Dist: <1ms(${distribution[0]}) | <8ms(${distribution[1]}) | <16ms(${distribution[2]}) | JANK(${distribution[3]})',
      isForce: true,
    );
  }
}

class _BatchCollector {
  final String label;
  final String? tag;
  int totalUs = 0;
  int count = 0;
  DateTime lastLogTime = DateTime.now();

  _BatchCollector(this.label, this.tag);

  void add(int us) {
    totalUs += us;
    count++;

    if (DateTime.now().difference(lastLogTime).inMilliseconds > 16 || count >= 100) {
      _flush();
    }
  }

  void _flush() {
    final double ms = totalUs / 1000;
    GaplyLogger.i(
      '📦 [BATCH] $label${tag != null ? ' @$tag' : ''} : '
      '${ms.toStringAsFixed(3)}ms (Total for $count calls)',
      isForce: true,
    );
    totalUs = 0;
    count = 0;
    lastLogTime = DateTime.now();
  }
}
