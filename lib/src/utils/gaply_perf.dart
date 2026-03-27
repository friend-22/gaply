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

  GaplyConsoleLogger({Duration? interval}) {
    _throttler = Throttler(
      interval: interval ?? const Duration(milliseconds: 100),
      onUpdate: (value) => debugPrint(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
  }

  GaplyConsoleLogger.noThrottler() {
    _throttler = Throttler(
      interval: Duration.zero,
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
    Duration? interval,
    FileMode mode = FileMode.append,
    this.maxBytes = 5 * 1024 * 1024,
  }) : file = File(path),
       _mode = mode {
    _throttler = Throttler(
      interval: interval ?? const Duration(milliseconds: 100),
      onUpdate: (value) => _write(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
    _initSink();
  }

  GaplyFileLogger.noThrottler(String path, {FileMode mode = FileMode.append, this.maxBytes = 5 * 1024 * 1024})
    : file = File(path),
      _mode = mode {
    _throttler = Throttler(
      interval: Duration.zero,
      onUpdate: (value) => debugPrint(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
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

// --- [Part 2] Gaply Profiler (The Engine) ---

class GaplyProfiler {
  GaplyProfiler._();

  static bool showOnlyOverThreshold = true;
  static bool canLogger = true;

  // Sync Trace
  static T trace<T>(String title, T Function() operation, {int thresholdUs = 0}) {
    if (!kDebugMode) return operation();
    final sw = Stopwatch()..start();
    final result = operation();
    sw.stop();
    _handleLog(title, sw.elapsedMicroseconds, thresholdUs);
    return result;
  }

  // Async Trace
  static Future<T> traceAsync<T>(String title, Future<T> Function() operation, {int thresholdUs = 0}) async {
    if (!kDebugMode) return await operation();
    final sw = Stopwatch()..start();
    try {
      final result = await operation();
      sw.stop();
      _handleLog(title, sw.elapsedMicroseconds, thresholdUs, isAsync: true);
      return result;
    } catch (e) {
      sw.stop();
      GaplyLogger.i('❌ [$title] Error (${sw.elapsedMilliseconds}ms): $e');
      rethrow;
    }
  }

  // Predefined Thresholds
  static T traceNano<T>(String title, T Function() op) => trace(title, op, thresholdUs: 100);
  static T trace240<T>(String title, T Function() op) => trace(title, op, thresholdUs: 250);
  static T trace120<T>(String title, T Function() op) => trace(title, op, thresholdUs: 500);

  static void _handleLog(String title, int us, int thresholdUs, {bool isAsync = false}) {
    if (!canLogger) return;
    if (showOnlyOverThreshold && us < thresholdUs) return;

    final ms = us / 1000;
    String colorTag = '';
    String statusLabel = '';

    // Status Logic
    if (isAsync) {
      if (ms > 500) {
        colorTag = '\x1B[31m';
        statusLabel = '![CRIT]';
      } else {
        colorTag = '\x1B[34m';
        statusLabel = '.[ASYNC]';
      }
    } else {
      if (us > 5000) {
        colorTag = '\x1B[31m';
        statusLabel = '![BAD ]';
      } else if (us > 1000) {
        colorTag = '\x1B[33m';
        statusLabel = '*[SLOW]';
      } else {
        colorTag = '\x1B[32m';
        statusLabel = '.[GOOD]';
      }
    }

    final reset = '\x1B[0m';
    final gray = '\x1B[90m';

    final timeStr = '${ms.toStringAsFixed(3)}ms'.padLeft(9);
    final formattedTitle = title.length > 30 ? '${title.substring(0, 27)}...' : title.padRight(30);
    final ratio = thresholdUs > 0 ? (us / thresholdUs * 100).toInt() : 100;
    final timestamp = DateTime.now().toIso8601String().split('T').last.substring(0, 8);

    GaplyLogger.i(
      '$gray[$timestamp]$reset $colorTag$statusLabel$reset $formattedTitle : '
      '$colorTag$timeStr$reset $gray($usμs)$reset | '
      '${ratio > 100 ? colorTag : gray}Budget: ${ratio.toString().padLeft(4)}%$reset',
    );
  }
}
