import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:gaply/src/utils/throttler.dart';

// --- [Part 1] Gaply Logger System ---

abstract class GaplyLogger {
  void log(String message, {bool isForce = false});

  // 전역 인스턴스 (초기화 전에는 빈 로거로 설정)
  static GaplyLogger _instance = _GaplyNoOpLogger();

  static void init(List<GaplyLogger> loggers) {
    _instance = GaplyCompositeLogger(loggers);
  }

  /// 앱 시작 시 호출하여 사용할 로거들을 설정합니다.
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

  static void i(String message, {bool isForce = false}) {
    if (!kDebugMode && !isForce) return;
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
  late final Throttler _throttler;

  GaplyConsoleLogger({Duration interval = Duration.zero}) {
    _throttler = Throttler(
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
  late final Throttler _throttler;
  IOSink? _sink;

  int _currentFileBytes = 0;

  GaplyFileLogger(
    String path, {
    Duration interval = Duration.zero,
    FileMode mode = FileMode.append,
    this.maxBytes = 5 * 1024 * 1024,
  }) : file = File(path),
       _mode = mode {
    _throttler = Throttler(
      interval: interval,
      onUpdate: (value) => _write(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
    _initSink();
  }

  void _initSink() {
    try {
      if (file.existsSync()) {
        _currentFileBytes = file.lengthSync();
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

  void _write(String message) {
    try {
      final String logEntry = '${DateTime.now().toIso8601String()} | $message\n';
      final List<int> bytes = utf8.encode(logEntry);

      if (_currentFileBytes + bytes.length > maxBytes) {
        _rotateFileSync();
      }

      _sink?.add(bytes);
      _currentFileBytes += bytes.length;
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Error: $e');
    }
  }

  void _rotateFileSync() {
    try {
      _sink?.close(); // 현재 스트림 닫기

      final oldFile = File('${file.path}.old');
      if (oldFile.existsSync()) oldFile.deleteSync();

      if (file.existsSync()) {
        file.renameSync(oldFile.path);
      }

      _currentFileBytes = 0;
      _initSink();
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Rotation Error: $e');
    }
  }

  Future<void> dispose() async {
    await _sink?.flush();
    await _sink?.close();
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

enum GaplyProfilerFilter { bad, over5000, slowBad, over1000, all }

class GaplyProfiler {
  final String label;
  final bool enabled;
  final int thresholdUs;
  final GaplyProfilerFilter filter;

  const GaplyProfiler({
    required this.label,
    this.enabled = false,
    this.thresholdUs = 500,
    this.filter = GaplyProfilerFilter.bad,
  });

  const GaplyProfiler.none()
    : label = 'none',
      enabled = false,
      thresholdUs = 0,
      filter = GaplyProfilerFilter.bad;

  const GaplyProfiler.tracePerfect({
    required this.label,
    this.enabled = true,
    this.filter = GaplyProfilerFilter.bad,
  }) : thresholdUs = 0;

  const GaplyProfiler.traceNano({
    required this.label,
    this.enabled = true,
    this.filter = GaplyProfilerFilter.bad,
  }) : thresholdUs = 100;

  const GaplyProfiler.trace240({
    required this.label,
    this.enabled = true,
    this.filter = GaplyProfilerFilter.bad,
  }) : thresholdUs = 250;

  const GaplyProfiler.trace120({
    required this.label,
    this.enabled = true,
    this.filter = GaplyProfilerFilter.bad,
  }) : thresholdUs = 500;

  const GaplyProfiler.trace60({
    required this.label,
    this.enabled = true,
    this.filter = GaplyProfilerFilter.bad,
  }) : thresholdUs = 1000;

  T trace<T>(T Function() operation, {String? tag}) {
    if (!enabled || !kDebugMode) return operation();

    final sw = Stopwatch()..start();
    final result = operation();
    sw.stop();

    _log(sw.elapsedMicroseconds, tag: tag);
    return result;
  }

  Future<T> traceAsync<T>(Future<T> Function() operation, {String? tag}) async {
    if (!enabled || !kDebugMode) return await operation();

    final sw = Stopwatch()..start();

    try {
      final result = await operation();
      sw.stop();
      _log(sw.elapsedMicroseconds, tag: tag, isAsync: true);
      return result;
    } catch (e) {
      sw.stop();
      GaplyLogger.i('❌ [$label] Error (${sw.elapsedMilliseconds}ms): $e');
      rethrow;
    }
  }

  void _log(int us, {String? tag, bool isAsync = false}) {
    int effectiveThreshold;

    switch (filter) {
      case GaplyProfilerFilter.bad:
      case GaplyProfilerFilter.over5000:
        effectiveThreshold = 5000; // 5ms
        break;
      case GaplyProfilerFilter.slowBad:
      case GaplyProfilerFilter.over1000:
        effectiveThreshold = 1000; // 1ms
        break;
      case GaplyProfilerFilter.all:
        effectiveThreshold = 0; // 전부 다
        break;
    }

    if (us < effectiveThreshold) return;

    final ms = us / 1000;
    String colorTag = '';
    String statusLabel = '';

    // Status Logic
    if (isAsync) {
      if (ms > 500) {
        colorTag = '\x1B[31m';
        statusLabel = '[CRIT]';
      } else {
        colorTag = '\x1B[34m';
        statusLabel = '[ASYNC]';
      }
    } else {
      if (us > 5000) {
        colorTag = '\x1B[31m';
        statusLabel = '[BAD ]';
      } else if (us > 1000) {
        colorTag = '\x1B[33m';
        statusLabel = '[SLOW]';
      } else {
        colorTag = '\x1B[32m';
        statusLabel = '[GOOD]';
      }
    }

    final reset = '\x1B[0m';
    final gray = '\x1B[90m';

    final String tagStr = tag != null ? ' $gray@$tag$reset' : '';
    final timeStr = '${ms.toStringAsFixed(3)}ms'.padLeft(9);
    final formattedTitle = label.length > 30 ? '${label.substring(0, 27)}...' : label.padRight(30);
    final ratio = thresholdUs > 0 ? (us / thresholdUs * 100).toInt() : 100;
    final timestamp = DateTime.now().toIso8601String().split('T').last.substring(0, 8);

    GaplyLogger.i(
      '$gray[$timestamp]$reset $colorTag$statusLabel$reset $formattedTitle$tagStr : '
      '$colorTag$timeStr$reset $gray($usμs)$reset | '
      '${ratio > 100 ? colorTag : gray}Budget: ${ratio.toString().padLeft(4)}%$reset',
    );
  }
}
