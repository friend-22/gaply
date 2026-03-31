// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:convert';
import 'dart:io' show FileMode, File, IOSink;

import 'package:gaply/src/utils/gaply_throttler.dart';
import 'package:flutter/material.dart';

enum GaplyLogLevel { debug, info, warning, error, none }

abstract class GaplyLogger {
  static GaplyLogLevel level = GaplyLogLevel.debug;

  void log(String message, {bool isForce = false});

  static GaplyLogger _instance = _GaplyNoOpLogger();

  static void init(List<GaplyLogger> loggers) {
    _instance = GaplyCompositeLogger(loggers);
  }

  static void allInit({
    bool enableConsole = true,
    String? filePath,
    FileMode fileMode = FileMode.append,
    int memoryCapacity = 1000,
  }) {
    final List<GaplyLogger> loggers = [];

    if (enableConsole) {
      loggers.add(GaplyConsoleLogger());
    }

    if (filePath != null) {
      loggers.add(GaplyFileLogger(filePath, mode: fileMode));
    }

    loggers.add(GaplyMemoryLogger(maxCapacity: memoryCapacity));

    _instance = GaplyCompositeLogger(loggers);
  }

  static void i(String message, {bool isForce = false, GaplyLogLevel logLevel = GaplyLogLevel.info}) {
    if (logLevel.index < level.index && !isForce) return;

    _instance.log(message, isForce: isForce);
  }

  factory GaplyLogger.console() => GaplyConsoleLogger();
  factory GaplyLogger.memory({int max = 1000}) => GaplyMemoryLogger(maxCapacity: max);
}

class _GaplyNoOpLogger implements GaplyLogger {
  @override
  void log(String message, {bool isForce = false}) {}
}

class GaplyConsoleLogger implements GaplyLogger {
  late final GaplyThrottler _throttler;

  GaplyConsoleLogger({Duration interval = Duration.zero}) {
    _throttler = GaplyThrottler(
      interval: interval,
      onUpdate: (value) => debugPrint(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
  }

  @override
  void log(String message, {bool isForce = false}) {
    if (isForce) {
      _throttler.flush(message);
    } else {
      _throttler.update(message);
    }
  }
}

class GaplyMemoryLogger implements GaplyLogger {
  final List<String> _logs = [];
  final int maxCapacity;
  GaplyMemoryLogger({this.maxCapacity = 1000});

  @override
  void log(String message, {bool isForce = false}) {
    if (_logs.length >= maxCapacity) _logs.removeAt(0);
    _logs.add(message);
  }

  List<String> get allLogs => List.unmodifiable(_logs);
}

class GaplyFileLogger implements GaplyLogger {
  final File file;
  final int maxBytes;
  final FileMode _mode;
  late final GaplyThrottler _throttler;
  IOSink? _sink;
  int _currentFileBytes = 0;

  Future<void> _lock = Future.value();

  GaplyFileLogger(
    String path, {
    Duration interval = Duration.zero,
    FileMode mode = FileMode.append,
    this.maxBytes = 5 * 1024 * 1024,
  }) : file = File(path),
       _mode = mode {
    _throttler = GaplyThrottler(
      interval: interval,
      onUpdate: (value) => _enqueue(() => _writeAsync(value)),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );

    _enqueue(_initLogger);
  }

  void _enqueue(FutureOr<void> Function() task) {
    _lock = _lock.then((_) => task()).catchError((e) {
      debugPrint('❌ GaplyFileLogger Task Error: $e');
    });
  }

  Future<void> _initLogger() async {
    try {
      if (await file.exists()) {
        _currentFileBytes = await file.length();
      } else {
        _currentFileBytes = 0;
      }
      _sink = file.openWrite(mode: _mode, encoding: utf8);
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Init Error: $e');
    }
  }

  @override
  void log(String message, {bool isForce = false}) {
    if (isForce) {
      _throttler.flush(message);
    } else {
      _throttler.update(message);
    }
  }

  Future<void> _writeAsync(String message) async {
    if (_sink == null) return;

    try {
      final String logEntry = '${DateTime.now().toIso8601String()} | $message\n';
      final List<int> bytes = utf8.encode(logEntry);

      if (_currentFileBytes + bytes.length > maxBytes) {
        await _rotateFileAsync();
      }

      _sink?.add(bytes);
      _currentFileBytes += bytes.length;
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Write Error: $e');
    }
  }

  Future<void> _rotateFileAsync() async {
    try {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;

      final oldFile = File('${file.path}.old');

      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      if (await file.exists()) {
        await file.rename(oldFile.path);
      }

      _currentFileBytes = 0;
      await _initLogger();
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Rotation Error: $e');
    }
  }

  Future<void> dispose() async {
    await _lock.then((_) async {
      await _sink?.flush();
      await _sink?.close();
    });
  }

  Future<String?> readAllLogs() async {
    if (!await file.exists()) return null;
    return await file.readAsString();
  }

  Future<List<File>> getLogFiles() async {
    final List<File> files = [file];
    final oldFile = File('${file.path}.old');
    if (await oldFile.exists()) files.add(oldFile);
    return files;
  }
}

class GaplyCompositeLogger implements GaplyLogger {
  final List<GaplyLogger> loggers;
  GaplyCompositeLogger(this.loggers);

  @override
  void log(String message, {bool isForce = false}) {
    for (var l in loggers) {
      l.log(message, isForce: isForce);
    }
  }
}
