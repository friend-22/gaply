import 'package:gaply/src/hub/logger/gaply_console_logger.dart';
import 'package:gaply/src/hub/logger/gaply_logger.dart';
import 'package:gaply/src/hub/logger/gaply_logger_base.dart';
import 'package:gaply/src/hub/profiler/gaply_batch_engine.dart';
import 'package:gaply/src/hub/profiler/gaply_memory_engine.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler_base.dart';
import 'package:gaply/src/hub/profiler/gaply_trace_engine.dart';

import 'gaply_budget.dart';

class GaplyHub {
  static GaplyAnsiTheme theme = GaplyAnsiTheme.dark;

  static final Map<Object, GaplyLoggerEngine> engines = {};

  static void initialize({List<GaplyLoggerEngine>? loggers}) {
    GaplyLogger.initialize(loggers ?? [GaplyConsoleLogger()]);
  }

  static void addCustomLogger(GaplyLoggerEngine engine) {
    GaplyLogger.addCustomLogger(engine);
  }

  static Future<void> dispose() async {
    await GaplyLogger.dispose();
    await Future.wait(engines.values.map((e) => e.dispose()));
    engines.clear();
  }

  set logLevel(GaplyLogLevel level) => GaplyLogger.level = level;
  static void info(String text, {bool isForce = false}) => GaplyLogger.info(text, isForce: isForce);
  static void debug(String text, {bool isForce = false}) => GaplyLogger.debug(text, isForce: isForce);
  static void warning(String text, {bool isForce = true}) => GaplyLogger.warning(text, isForce: isForce);
  static void error(String text, {bool isForce = true}) => GaplyLogger.error(text, isForce: isForce);

  static GaplyProfilerEngine traceEngine({
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
    GaplyLoggerEngine? customLogger,
  }) {
    final finalThreshold = threshold ?? GaplyBudget.smooth60;
    final finalMaxKeys = maxKeys ?? 500;
    final finalMaxIdleTime = maxIdleTime ?? const Duration(minutes: 5);
    return GaplyTraceEngine(
      threshold: finalThreshold,
      maxKeys: finalMaxKeys,
      maxIdleTime: finalMaxIdleTime,
      customLogger: customLogger,
    );
  }

  static GaplyProfilerEngine batchEngine({
    Duration? threshold,
    int? maxBatchCount,
    Duration? maxBatchInterval,
    int? maxKeys,
    Duration? maxIdleTime,
    GaplyLoggerEngine? customLogger,
  }) {
    final finalThreshold = threshold ?? GaplyBudget.all;
    final finalMaxBatchCount = maxBatchCount ?? 100;
    final finalMaxBatchInterval = maxBatchInterval ?? GaplyBudget.fps60;
    final finalMaxKeys = maxKeys ?? 500;
    final finalMaxIdleTime = maxIdleTime ?? const Duration(minutes: 5);

    return GaplyBatchEngine(
      threshold: finalThreshold,
      maxBatchCount: finalMaxBatchCount,
      maxBatchInterval: finalMaxBatchInterval,
      maxKeys: finalMaxKeys,
      maxIdleTime: finalMaxIdleTime,
      customLogger: customLogger,
    );
  }

  static GaplyProfilerEngine memoryEngine({
    int? thresholdBytes,
    int? maxKeys,
    Duration? maxIdleTime,
    GaplyLoggerEngine? customLogger,
  }) {
    final finalThresholdBytes = thresholdBytes ?? GaplyBudget.mb1;
    final finalMaxKeys = maxKeys ?? 500;
    final finalMaxIdleTime = maxIdleTime ?? const Duration(minutes: 5);
    return GaplyMemoryEngine(
      thresholdBytes: finalThresholdBytes,
      maxKeys: finalMaxKeys,
      maxIdleTime: finalMaxIdleTime,
      customLogger: customLogger,
    );
  }
}

enum GaplyAnsiTheme { light, dark }

extension GaplyAnsiThemeExtension on GaplyAnsiTheme {
  GaplyAnsi get ansi =>
      this == GaplyAnsiTheme.dark ? GaplyAnsi(GaplyAnsiTheme.dark) : GaplyAnsi(GaplyAnsiTheme.light);

  GaplyFormatter get formatter => GaplyFormatter(ansi);
}

class GaplyAnsi {
  final GaplyAnsiTheme theme;
  GaplyAnsi(this.theme);

  bool get isDark => theme == GaplyAnsiTheme.dark;

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

  String get error => jank;
  String get warning => warn;
  String get info => perf;

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
