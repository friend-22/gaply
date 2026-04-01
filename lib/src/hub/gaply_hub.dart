import 'dart:io';
import 'dart:isolate';

import 'package:gaply/src/hub/logger/gaply_console_logger.dart';
import 'package:gaply/src/hub/logger/gaply_logger.dart';
import 'package:gaply/src/hub/logger/gaply_logger_base.dart';

import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/hub/profiler/gaply_batch_engine.dart';
import 'package:gaply/src/hub/profiler/gaply_memory_engine.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler_base.dart';
import 'package:gaply/src/hub/profiler/gaply_trace_engine.dart';

import 'gaply_budget.dart';
import 'logger/gaply_file_logger.dart';

class GaplyHub {
  static GaplyAnsiTheme theme = GaplyAnsiTheme.dark;

  static final Map<String, GaplyProfiler> _profilers = {};
  static final Map<String, GaplyIsolateChannel> _channels = {};

  static void initialize({List<GaplyLoggerEngine>? loggers}) {
    GaplyLogger.initialize(loggers ?? [GaplyConsoleLogger()]);
  }

  static Future<void> dispose() async {
    await GaplyLogger.dispose();

    for (var profiler in _profilers.values) {
      await profiler.dispose();
    }
    _profilers.clear();

    for (var channel in _channels.values) {
      channel.dispose();
    }
    _channels.clear();
  }

  static GaplyIsolateChannel createChannel(String id, Function(dynamic) onMessage) {
    if (_channels.containsKey(id)) {
      return _channels[id]!;
    }

    final channel = GaplyIsolateChannel(onMessage);
    _channels[id] = channel;
    return channel;
  }

  static void removeChannel(String id) {
    if (!_channels.containsKey(id)) return;

    _channels[id]?.dispose();
    _channels.remove(id);
  }

  static GaplyIsolateChannel? getChannel(String id) => _channels[id];
  static SendPort? getSendPort(String id) => _channels[id]?.sendPort;

  static void report(String label) {
    _profilers[label]?.printStats();
  }

  static void reportAll() {
    for (var profiler in _profilers.values) {
      profiler.printStats();
    }
  }

  static set logLevel(GaplyLogLevel level) => GaplyLogger.level = level;
  static void info(String text, {bool isForce = false}) => GaplyLogger.info(text, isForce: isForce);
  static void debug(String text, {bool isForce = false}) => GaplyLogger.debug(text, isForce: isForce);
  static void warning(String text, {bool isForce = true}) => GaplyLogger.warning(text, isForce: isForce);
  static void error(String text, {bool isForce = true}) => GaplyLogger.error(text, isForce: isForce);

  static GaplyLoggerEngine fileLogger(
    String path, {
    required String id,
    Duration? interval,
    FileMode? mode,
    int? maxBytes,
    int? bufferCapacity,
    Duration? flushInterval,
  }) {
    final finalMode = mode ?? FileMode.append;
    final finalInterval = interval ?? Duration.zero;
    final finalMaxBytes = maxBytes ?? 5 * 1024 * 1024;
    final finalBufferCapacity = bufferCapacity ?? 20;
    final finalFlushInterval = flushInterval ?? Duration(seconds: 5);

    final engine = GaplyFileLogger(
      path,
      id: id,
      interval: finalInterval,
      mode: finalMode,
      maxBytes: finalMaxBytes,
      bufferCapacity: finalBufferCapacity,
      flushInterval: finalFlushInterval,
    );
    GaplyLogger.addCustomLogger(engine);
    return engine;
  }

  static GaplyProfiler createProfiler({
    required String label,
    bool? enabled,
    List<GaplyProfilerEngine>? children,
  }) {
    if (_profilers.containsKey(label)) {
      return _profilers[label]!;
    }

    final profiler = GaplyProfiler(label: label, enabled: enabled ?? true, children: children);
    _profilers[label] = profiler;
    return profiler;
  }

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

class GaplyIsolateChannel {
  final ReceivePort _receivePort = ReceivePort();

  GaplyIsolateChannel(Function(dynamic) onMessage) {
    _receivePort.listen((packet) => onMessage(packet));
  }

  SendPort get sendPort => _receivePort.sendPort;

  void dispose() => _receivePort.close();
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
