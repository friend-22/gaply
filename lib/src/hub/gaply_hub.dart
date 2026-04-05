import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint, immutable;
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';

import 'gaply_ansi.dart';
import 'gaply_budget.dart';
import 'isolate/gaply_isolate.dart';

part 'logger/console_logger.dart';
part 'logger/file_logger.dart';
part 'logger/logger.dart';
part 'logger/logger_base.dart';
part 'logger/logger_worker_helper.dart';
part 'logger/gaply_logger_spec.dart';
part 'logger/logger_worker.dart';
part 'logger/memory_logger.dart';

enum GaplyLogLevel { debug, info, warning, error, none }

class GaplyHub {
  static GaplyAnsiTheme _theme = GaplyAnsiTheme.dark;
  static GaplyLogLevel _logLevel = GaplyLogLevel.debug;

  static GaplyAnsiTheme get theme => _theme;
  static set theme(GaplyAnsiTheme theme) {
    _theme = theme;
    _logWorker.setTheme(theme);
  }

  static GaplyLogLevel get logLevel => _logLevel;
  static set logLevel(GaplyLogLevel level) {
    _logLevel = level;
    _logWorker.setLevel(level);
  }

  static const int memoryTrackIntervalMs = GaplyBudget.memoryTrack60;

  static final Map<String, GaplyProfiler> _profilers = {};
  static final _LoggerWorker _logWorker = _LoggerWorker();

  static void addDefaultLogger(GaplyLoggerSpec logger) {
    _logWorker.addDefaultLogger(logger);
  }

  static void removeDefaultLogger(GaplyLoggerSpec logger) {
    _logWorker.removeDefaultLogger(logger);
  }

  static void addCustomLogger(GaplyLoggerSpec logger) {
    _logWorker.addCustomLogger(logger);
  }

  static void removeCustomLogger(GaplyLoggerSpec logger) {
    _logWorker.removeCustomLogger(logger);
  }

  static Future<void> dispose() async {
    for (var profiler in _profilers.values) {
      await profiler.dispose();
    }
    _profilers.clear();

    await _logWorker.dispose();

    await GaplyChannelPool.dispose();
    await GaplyWorkerPool.dispose();
  }

  static GaplyProfiler createProfiler({required String id, bool? enabled, List<GaplyEngineSpec>? specs}) {
    if (_profilers.containsKey(id)) {
      return _profilers[id]!;
    }

    final profiler = GaplyProfiler(id: id, specs: specs, engineIds: []);
    _profilers[id] = profiler;
    return profiler;
  }

  static void report(String label) {
    _profilers[label]?.printStats();
  }

  static void reportByProfiler(GaplyProfiler profiler) {
    _profilers[profiler.id]?.printStats();
  }

  static Future<void> reportAll() async {
    _logWorker.flush();

    for (var profiler in _profilers.values) {
      await profiler.printStats();
    }
  }

  static void flush() => _logWorker.flush();
  static void dispatch(String text, GaplyLogLevel level, bool isImmediate, {String? engineId}) =>
      _logWorker.dispatch(text, level, isImmediate, engineId: engineId);
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
}
