import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_utils.dart';

import 'gaply_ansi.dart';
import 'gaply_budget.dart';
import 'logger/gaply_logger_spec.dart';

part 'gaply_channel.dart';

part 'logger/gaply_logger.dart';
part 'logger/gaply_logger_base.dart';
part 'logger/gaply_console_logger.dart';
part 'logger/gaply_file_logger.dart';
part 'logger/gaply_memory_logger.dart';

class GaplyHub {
  static GaplyAnsiTheme theme = GaplyAnsiTheme.dark;
  static Duration memoryTrackInterval = GaplyBudget.fps60;

  static final Map<String, GaplyProfiler> _profilers = {};
  static final _GaplyLogger _logger = _GaplyLogger();

  static void addDefaultLogger(GaplyLoggerSpec logger) {
    _logger.addDefaultLogger(logger);
  }

  static void removeDefaultLogger(GaplyLoggerSpec logger) {
    _logger.removeDefaultLogger(logger);
  }

  static void addCustomLogger(GaplyLoggerSpec logger) {
    _logger.addCustomLogger(logger);
  }

  static void removeCustomLogger(GaplyLoggerSpec logger) {
    _logger.removeCustomLogger(logger);
  }

  static Future<void> dispose() async {
    _logger._defaultEngine.flush();

    for (var profiler in _profilers.values) {
      await profiler.dispose();
    }
    _profilers.clear();

    await _logger.dispose();

    GaplyChannelPool.dispose();
  }

  static GaplyProfiler createProfiler({required String id, bool? enabled, List<GaplyEngineSpec>? specs}) {
    String cleanId = GaplyUtils.cleanId(id);

    if (_profilers.containsKey(cleanId)) {
      return _profilers[cleanId]!;
    }

    final profiler = GaplyProfiler.withSpecs(id: cleanId, enabled: enabled ?? true, specs: specs);
    _profilers[cleanId] = profiler;
    return profiler;
  }

  static void report(String label) {
    _profilers[label]?.printStats();
  }

  static void reportByProfiler(GaplyProfiler profiler) {
    _profilers[profiler.id]?.printStats();
  }

  static Future<void> reportAll() async {
    await _logger._defaultEngine.flush();

    for (var profiler in _profilers.values) {
      await profiler.printStats();
    }
  }

  static set logLevel(GaplyLogLevel level) => _GaplyLogger.level = level;
  static void dispatch(String text, GaplyLogLevel level, bool isImmediate, {String? engineId}) =>
      _logger.dispatch(text, level, isImmediate, engineId: engineId);
  static void info(String text, {bool isImmediate = false}) =>
      dispatch(text, GaplyLogLevel.info, isImmediate, engineId: null);
  static void debug(String text, {bool isImmediate = false}) =>
      dispatch(text, GaplyLogLevel.debug, isImmediate, engineId: null);
  static void warning(String text, {bool isImmediate = true}) =>
      dispatch(text, GaplyLogLevel.warning, isImmediate, engineId: null);
  static void error(String text, {bool isImmediate = true}) =>
      dispatch(text, GaplyLogLevel.error, isImmediate, engineId: null);
  static void none(String text, {bool isImmediate = false}) =>
      dispatch(text, GaplyLogLevel.none, isImmediate, engineId: null);
  static Future<void> flush() async => await _logger._defaultEngine.flush();

  // static GaplyLoggerEngine fileLogger(
  //   String path, {
  //   required String id,
  //   Duration? interval,
  //   FileMode? mode,
  //   int? maxBytes,
  //   int? bufferCapacity,
  //   Duration? flushInterval,
  // }) {
  //   final finalMode = mode ?? FileMode.append;
  //   final finalInterval = interval ?? Duration.zero;
  //   final finalMaxBytes = maxBytes ?? 5 * 1024 * 1024;
  //   final finalBufferCapacity = bufferCapacity ?? 20;
  //   final finalFlushInterval = flushInterval ?? Duration(seconds: 5);
  //
  //   final engine = GaplyFileLogger(
  //     path,
  //     id: id,
  //     interval: finalInterval,
  //     mode: finalMode,
  //     maxBytes: finalMaxBytes,
  //     bufferCapacity: finalBufferCapacity,
  //     flushInterval: finalFlushInterval,
  //   );
  //   _logger.addCustomLogger(engine);
  //   return engine;
  // }
}
