import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'gaply_logger.dart';
import 'gaply_batch_profiler.dart';
import 'gaply_budget.dart';
import 'gaply_memory_profiler.dart';
import 'gaply_trace_profiler.dart';

abstract class GaplyProfileEngine {
  /// Records the elapsed time for a specific task
  void record(
    Duration elapsed, {
    required int memoryDelta,
    required String label,
    String? tag,
    int? depth,
    bool isAsync = false,
  });

  /// Prints summarized statistics for the given label
  void printStats(String label);
}

class GaplyProfiler {
  final bool enabled;
  final String label;
  final List<GaplyProfileEngine> children;

  static const Object _depthKey = #gaply_profiler_depth;
  static GaplyProfilerTheme theme = GaplyProfilerTheme.dark;

  const GaplyProfiler({required this.label, this.enabled = true, List<GaplyProfileEngine>? children})
    : children = children ?? const [];

  const GaplyProfiler.none() : label = 'none', enabled = false, children = const [];

  static GaplyProfileEngine traceEngine({Duration? threshold}) {
    return GaplyTraceEngine(threshold: threshold ?? GaplyBudget.smooth60);
  }

  static GaplyProfileEngine batchEngine({
    Duration? threshold,
    int? maxBatchCount,
    Duration? maxBatchInterval,
  }) {
    return GaplyBatchEngine(
      threshold: threshold ?? GaplyBudget.all,
      maxBatchInterval: maxBatchInterval ?? GaplyBudget.fps60,
      maxBatchCount: maxBatchCount ?? 100,
    );
  }

  static GaplyProfileEngine memoryEngine({int? thresholdBytes}) {
    return GaplyMemoryEngine(thresholdBytes: thresholdBytes ?? GaplyBudget.zeroBytes);
  }

  int get _currentDepth => Zone.current[_depthKey] as int? ?? 0;

  void _notifyAll(Duration elapsed, int deltaMem, {String? tag, int? depth, bool isAsync = false}) {
    for (var child in children) {
      child.record(elapsed, memoryDelta: deltaMem, label: label, tag: tag, depth: depth, isAsync: isAsync);
    }
  }

  /// Executes and traces the performance of a given operation
  T trace<T>(T Function() operation, {String? tag}) {
    if (!enabled || !kDebugMode || children.isEmpty) {
      return operation();
    }
    return runZoned(() {
      final int startMem = ProcessInfo.currentRss;
      final sw = Stopwatch()..start();

      try {
        final result = operation();

        if (result is Future) {
          return result.whenComplete(() {
                sw.stop();
                final int endMem = ProcessInfo.currentRss;
                final int deltaMem = endMem - startMem;

                _notifyAll(sw.elapsed, deltaMem, tag: tag, depth: _currentDepth - 1, isAsync: true);
              })
              as T;
        }

        sw.stop();
        final int endMem = ProcessInfo.currentRss;
        final int deltaMem = endMem - startMem;

        _notifyAll(sw.elapsed, deltaMem, tag: tag, depth: _currentDepth - 1, isAsync: false);
        return result;
      } catch (e) {
        sw.stop();
        GaplyLogger.i('❌ [ERROR] $label: $e');
        rethrow;
      }
    }, zoneValues: {_depthKey: _currentDepth + 1});
  }

  Future<T> traceAsync<T>(Future<T> Function() operation, {String? tag}) async {
    return trace(() => operation(), tag: tag);
  }

  void printStats() {
    GaplyLogger.i('\n--- [ $label - Final Performance Report ] ---', isForce: true);
    for (final child in children) {
      child.printStats(label);
      GaplyLogger.i('', isForce: true);
    }
  }
}

enum GaplyProfilerTheme { light, dark }

extension GaplyThemeExtension on GaplyProfilerTheme {
  GaplyAnsi get ansi => this == GaplyProfilerTheme.dark
      ? GaplyAnsi(GaplyProfilerTheme.dark)
      : GaplyAnsi(GaplyProfilerTheme.light);

  GaplyFormatter get formatter => GaplyFormatter(ansi);
}

class GaplyAnsi {
  final GaplyProfilerTheme theme;
  GaplyAnsi(this.theme);

  bool get isDark => theme == GaplyProfilerTheme.dark;

  String get reset => '\x1B[0m';

  String get gray => isDark ? '\x1B[38;5;243m' : '\x1B[38;5;244m';
  String get label => isDark ? '\x1B[37m' : '\x1B[30m';
  String get hint => isDark ? '\x1B[33m' : '\x1B[36m';
  String get tag => isDark ? '\x1B[94m' : '\x1B[34m';

  String get accent => isDark ? '\x1B[95m' : '\x1B[35m';

  String get perf => isDark ? '\x1B[92m' : '\x1B[32m'; // Bright Green
  String get norm => isDark ? '\x1B[93m' : '\x1B[33m'; // Bright Yellow
  String get warn => isDark ? '\x1B[38;5;208m' : '\x1B[33m'; // Orange
  String get jank => isDark ? '\x1B[91m' : '\x1B[31m'; // Bright Red
  String get async => isDark ? '\x1B[94m' : '\x1B[94m'; // Blue

  String colorByMs(double ms, double limit) {
    if (ms >= limit) return jank;
    if (ms > limit * 0.5) return warn;
    return perf;
  }
}

class GaplyFormatter {
  final GaplyAnsi ansi;
  GaplyFormatter(this.ansi);

  String formatMs(double ms, double limit, {bool showDiff = true}) {
    final color = ansi.colorByMs(ms, limit);
    final diff = ms - limit;
    final sign = diff > 0 ? '+' : '';
    final diffStr = showDiff ? ' ${ansi.gray}($sign${diff.toStringAsFixed(2)}ms)${ansi.reset}' : '';

    return '$color${ms.toStringAsFixed(3).padLeft(7)}ms${ansi.reset}$diffStr';
  }

  String formatDistRow(List<int> dist, int total) {
    percent(int count) => (count / total * 100).toStringAsFixed(1);
    return '${ansi.perf}✨Perf:${dist[0]}(${percent(dist[0])}%)${ansi.reset} | '
        '${ansi.norm}✅Norm:${dist[1]}(${percent(dist[1])}%)${ansi.reset} | '
        '${ansi.warn}⚠️Warn:${dist[2]}(${percent(dist[2])}%)${ansi.reset} | '
        '${ansi.jank}🚨JANK:${dist[3]}(${percent(dist[3])}%)${ansi.reset}';
  }
}
