import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:gaply/src/hub/logger/gaply_logger.dart';

import 'gaply_profiler_base.dart';

class GaplyProfiler {
  final bool enabled;
  final String label;
  final List<GaplyProfilerEngine> children;

  static const Object _depthKey = #gaply_profiler_depth;

  const GaplyProfiler({required this.label, this.enabled = true, List<GaplyProfilerEngine>? children})
    : children = children ?? const [];

  const GaplyProfiler.none() : label = 'none', enabled = false, children = const [];

  static int get _currentDepth {
    try {
      return Zone.current[_depthKey] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Executes and traces the performance of a given operation
  T trace<T>(T Function() operation, {String? tag}) {
    if (!enabled || !kDebugMode || children.isEmpty) {
      return operation();
    }

    final int nextDepth = _currentDepth + 1;
    final sw = Stopwatch()..start();
    final int startMem = ProcessInfo.currentRss;

    void recordFinal(bool isAsync, {bool isError = false}) {
      if (!sw.isRunning) return;
      _handleRecord(sw, startMem, isError ? '${tag ?? 'task'}:error' : tag, nextDepth, isAsync);
    }

    return runZoned(() {
      try {
        final result = operation();

        if (result is Future) {
          return result
                  .then((value) {
                    recordFinal(true);
                    return value;
                  })
                  .catchError((e) {
                    recordFinal(true, isError: true);
                    GaplyLogger.error('❌ [ASYNC ERROR] $label: $e');
                    throw e;
                  })
              as T;
        }

        recordFinal(false);
        return result;
      } catch (e) {
        recordFinal(false, isError: true);
        GaplyLogger.error('❌ [SYNC ERROR] $label: $e');
        rethrow;
      }
    }, zoneValues: {_depthKey: nextDepth});
  }

  Future<T> traceAsync<T>(
    Future<T> Function() operation, {
    String? tag,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return trace(() async {
      return await operation().timeout(timeout);
    }, tag: tag);
  }

  void _handleRecord(Stopwatch sw, int startMem, String? tag, int depth, bool isAsync) {
    sw.stop();
    final int endMem = ProcessInfo.currentRss;
    final int memoryDelta = endMem - startMem;

    String cleanLabel = _cleanLabel(label);
    String? cleanTag = _cleanTag(tag);

    final packet = ProfilePacket(
      elapsed: sw.elapsed,
      label: cleanLabel,
      tag: cleanTag,
      isAsync: isAsync,
      depth: depth,
      memoryDelta: memoryDelta,
    );

    for (var child in children) {
      child.record(packet);
    }
  }

  void printStats() {
    GaplyLogger.info('\n--- [ $label - Final Performance Report ] ---', isForce: true);
    for (final child in children) {
      child.printStats(label);
      GaplyLogger.info('', isForce: true);
    }
  }

  Future<void> dispose() async {
    for (final child in children) {
      await child.dispose();
    }
  }

  bool _isValidLabel(String label) => RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(label);
  bool _isValidTag(String? tag) => tag == null || RegExp(r'^[a-zA-Z0-9_:]+$').hasMatch(tag);

  String _cleanLabel(String label) {
    String cleanLabel = label;
    if (!_isValidLabel(label)) {
      cleanLabel = label.replaceAll(RegExp(r'[^a-zA-Z0-9_:]'), '_');
      GaplyLogger.info('⚠️ [Gaply] Invalid label "$label" sanitized to "$cleanLabel"');
    }
    return cleanLabel;
  }

  String? _cleanTag(String? tag) {
    String? cleanTag = tag;
    if (tag != null && !_isValidTag(tag)) {
      cleanTag = tag.replaceAll(RegExp(r'[^a-zA-Z0-9_:]'), '_');
      GaplyLogger.info('⚠️ [Gaply] Invalid tag "$tag" sanitized to "$cleanTag"');
    }
    return cleanTag;
  }
}
