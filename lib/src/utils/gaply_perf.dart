import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

// --- [Part 1] Gaply Logger System ---

abstract class GaplyLogger {
  void log(String message);

  factory GaplyLogger.console() => GaplyConsoleLogger();
  factory GaplyLogger.memory({int max = 1000}) => MemoryLogLogger(maxCapacity: max);
}

class GaplyConsoleLogger implements GaplyLogger {
  @override
  void log(String message) => debugPrint(message);
}

class MemoryLogLogger implements GaplyLogger {
  final List<String> _logs = [];
  final int maxCapacity;
  MemoryLogLogger({this.maxCapacity = 1000});

  @override
  void log(String message) {
    if (_logs.length >= maxCapacity) _logs.removeAt(0);
    _logs.add(message);
  }

  List<String> get allLogs => List.unmodifiable(_logs);
}

class GaplyFileLogger implements GaplyLogger {
  final File file;
  GaplyFileLogger(String path) : file = File(path);

  @override
  void log(String message) {
    file.writeAsStringSync('$message\n', mode: FileMode.append);
  }
}

class GaplyCompositeLogger implements GaplyLogger {
  final List<GaplyLogger> loggers;
  GaplyCompositeLogger(this.loggers);

  @override
  void log(String message) {
    for (var l in loggers) {
      l.log(message);
    }
  }
}

// --- [Part 2] Gaply Profiler (The Engine) ---

class GaplyProfiler {
  GaplyProfiler._();

  static GaplyLogger logger = GaplyLogger.console();
  static bool showOnlyOverThreshold = true;

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
      logger.log('❌ [$title] Error (${sw.elapsedMilliseconds}ms): $e');
      rethrow;
    }
  }

  // Predefined Thresholds
  static T traceNano<T>(String title, T Function() op) => trace(title, op, thresholdUs: 100);
  static T trace240<T>(String title, T Function() op) => trace(title, op, thresholdUs: 250);
  static T trace120<T>(String title, T Function() op) => trace(title, op, thresholdUs: 500);

  static void _handleLog(String title, int us, int thresholdUs, {bool isAsync = false}) {
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

    logger.log(
      '$gray[$timestamp]$reset $colorTag$statusLabel$reset $formattedTitle : '
      '$colorTag$timeStr$reset $gray(${us}μs)$reset | '
      '${ratio > 100 ? colorTag : gray}Budget: ${ratio.toString().padLeft(4)}%$reset',
    );
  }
}
