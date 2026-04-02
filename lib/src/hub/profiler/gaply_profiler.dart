import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gaply/src/hub/gaply_ansi.dart';

import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';

part 'gaply_profiler_base.dart';
part 'gaply_engine_specs.dart';
part 'gaply_batch_engine.dart';
part 'gaply_trace_engine.dart';
part 'gaply_memory_engine.dart';

class GaplyProfiler {
  final String id;
  final bool enabled;
  final List<GaplyProfilerEngine> _engines;
  bool _hasMemoryEngine = false;

  static const Object _depthKey = #gaply_profiler_depth;

  static int get _currentDepth {
    try {
      return Zone.current[_depthKey] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  GaplyProfiler({required this.id, this.enabled = true, List<GaplyProfilerEngine>? engines})
    : _engines = engines ?? const [];

  GaplyProfiler.none() : id = '', enabled = false, _engines = const [];

  GaplyProfiler.withSpecs({required this.id, this.enabled = true, List<GaplyEngineSpec>? specs})
    : _engines = [] {
    if (specs != null) {
      for (final spec in specs) {
        addEngine(spec);
      }
    }
  }

  GaplyProfiler addEngine(GaplyEngineSpec spec) {
    if (_engineExists(spec)) {
      GaplyHub.info('⚠️ [Gaply] Engine with this spec already exists: ${spec.id}');
      return this;
    }
    _engines.add(_createEngineFactory(spec));
    _hasMemoryEngine = _hasMemoryEngine || spec is GaplyMemoryEngineSpec;
    return this;
  }

  GaplyProfiler removeEngine(GaplyEngineSpec spec) {
    final targets = _engines.where((e) => e.spec == spec).toList();

    for (var engine in targets) {
      engine.dispose();
      _engines.remove(engine);
    }

    _hasMemoryEngine = _engines.any((e) => e is GaplyMemoryEngine);
    return this;
  }

  bool _engineExists(GaplyEngineSpec spec) {
    return _engines.any((e) => e.spec.id == spec.id && spec.id.isNotEmpty);
  }

  String _getCategoryName(GaplyEngineSpec spec) {
    if (spec is GaplyBatchEngineSpec) return GaplyBatchEngine.categoryName;
    if (spec is GaplyMemoryEngineSpec) return GaplyMemoryEngine.categoryName;
    if (spec is GaplyTraceEngineSpec) return GaplyTraceEngine.categoryName;
    return 'Unknown';
  }

  /// Executes and traces the performance of a given operation
  T trace<T>(T Function() operation, {String? tag, Map<String, dynamic>? metadata}) {
    if (!enabled || !kDebugMode || _engines.isEmpty) return operation();

    final nextDepth = _currentDepth + 1;
    final sw = Stopwatch()..start();
    final startMem = _hasMemoryEngine ? ProcessInfo.currentRss : 0;

    return runZoned(() {
      try {
        final result = operation();

        if (result is Future) {
          GaplyHub.warning('⚠️ [Gaply] Use traceAsync for Future operations.');
          return result;
        }

        _handleRecord(sw, startMem, tag, nextDepth, false, metadata);
        return result;
      } catch (e) {
        _handleRecord(sw, startMem, '${tag ?? 'task'}:error', nextDepth, false, metadata);
        rethrow;
      }
    }, zoneValues: {_depthKey: nextDepth});
  }

  Future<T> traceAsync<T>(
    Future<T> Function() operation, {
    String? tag,
    Map<String, dynamic>? metadata,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (!enabled || !kDebugMode || _engines.isEmpty) {
      return operation().timeout(timeout);
    }

    final nextDepth = _currentDepth + 1;
    final sw = Stopwatch()..start();
    final startMem = ProcessInfo.currentRss;

    return await runZoned(() async {
      try {
        final T result = await operation().timeout(timeout);
        _handleRecord(sw, startMem, tag, nextDepth, true, metadata);
        return result;
      } catch (e) {
        _handleRecord(sw, startMem, '${tag ?? 'task'}:error', nextDepth, true, metadata);
        GaplyHub.error('❌ [ASYNC ERROR] $id: $e');
        rethrow;
      }
    }, zoneValues: {_depthKey: nextDepth});
  }

  void _handleRecord(
    Stopwatch sw,
    int startMem,
    String? tag,
    int depth,
    bool isAsync,
    Map<String, dynamic>? metadata,
  ) {
    sw.stop();
    final int endMem = _hasMemoryEngine ? ProcessInfo.currentRss : 0;
    final int memoryDelta = endMem - startMem;

    String? cleanTag = _cleanTag(tag);

    final data = [sw.elapsedMicroseconds, id, cleanTag, isAsync ? 1 : 0, depth, memoryDelta, metadata];
    for (var child in _engines) {
      child.record(data);
    }
  }

  GaplyProfilerEngine _createEngineFactory(GaplyEngineSpec spec) {
    final String finalId = spec.id.isEmpty ? '${_getCategoryName(spec)} + $id' : spec.id;

    switch (spec) {
      case GaplyBatchEngineSpec s:
        return GaplyBatchEngine(spec: s.copyWith(id: finalId));
      case GaplyMemoryEngineSpec s:
        return GaplyMemoryEngine(spec: s.copyWith(id: finalId));
      case GaplyTraceEngineSpec s:
        return GaplyTraceEngine(spec: s.copyWith(id: finalId));
    }

    return _GaplyNoOpEngine();
  }

  Future<void> printStats() async {
    GaplyHub.info('\n--- [ $id - Final Performance Report ] ---', isImmediate: true);
    for (final child in _engines) {
      await child.printStats(id);
    }
  }

  Future<void> dispose() async {
    for (final child in _engines) {
      await child.dispose();
    }
  }

  bool _isValidTag(String? tag) => tag == null || RegExp(r'^[a-zA-Z0-9_:]+$').hasMatch(tag);

  String? _cleanTag(String? tag) {
    String? cleanTag = tag;
    if (tag != null && !_isValidTag(tag)) {
      cleanTag = tag.replaceAll(RegExp(r'[^a-zA-Z0-9_:]'), '_');
      GaplyHub.info('⚠️ [Gaply] Invalid tag "$tag" sanitized to "$cleanTag"');
    }
    return cleanTag;
  }
}

class _GaplyNoOpEngine extends GaplyProfilerEngine {
  static const String categoryName = '_GaplyNoOpEngine';

  @override
  final GaplyNoOpEngineSpec spec = const GaplyNoOpEngineSpec();

  @override
  String get category => _GaplyNoOpEngine.categoryName;

  _GaplyNoOpEngine();

  @override
  void record(dynamic data) {}

  @override
  void onDataReceived(dynamic data) {}
}
