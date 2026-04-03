import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gaply/src/hub/gaply_ansi.dart';

import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'package:gaply/src/utils/gaply_utils.dart';

part 'gaply_profiler_base.dart';
part 'gaply_engine_specs.dart';
part 'gaply_batch_engine.dart';
part 'gaply_trace_engine.dart';
part 'gaply_memory_engine.dart';

class GaplyProfiler {
  final String id;
  final bool enabled;
  final List<GaplyProfilerEngine> _engines;

  static const Object _depthKey = #gaply_profiler_depth;

  const GaplyProfiler({required this.id, this.enabled = true, List<GaplyProfilerEngine>? engines})
    : _engines = engines ?? const [];

  const GaplyProfiler.none() : id = '', enabled = false, _engines = const [];

  GaplyProfiler.withSpecs({required this.id, this.enabled = true, List<GaplyEngineSpec>? specs})
    : _engines = [] {
    if (specs != null) {
      for (final spec in specs) {
        addEngine(spec);
      }
    }
  }

  bool get _shouldTrackMemory => _engines.any((e) => e.enableMemoryTracking);
  bool get _canProfile => enabled && kDebugMode && _engines.isNotEmpty;

  static int get _currentDepth {
    try {
      return Zone.current[_depthKey] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  GaplyTraceHandle start({String? tag, Map<String, dynamic>? metadata}) {
    if (!_canProfile) return GaplyTraceHandle.noOp(id: id, tag: tag, metadata: metadata);

    final bool trackMem = _shouldTrackMemory;
    final sw = Stopwatch()..start();
    final int startMem = trackMem ? ProcessInfo.currentRss : 0;

    final args = List<dynamic>.filled(7, null);
    args[_Idx.sw] = sw;
    args[_Idx.id] = id;
    args[_Idx.tag] = tag;
    args[_Idx.async] = 0;
    args[_Idx.dep] = _currentDepth;
    args[_Idx.mem] = 0;
    args[_Idx.meta] = metadata;

    return GaplyTraceHandle._(args: args, startMem: startMem, trackMemory: trackMem, onStop: _handleRecord);
  }

  /// Executes and traces the performance of a given operation
  T trace<T>(T Function() operation, {String? tag, Map<String, dynamic>? metadata}) {
    return _runTrace<T>(
          () {
            final result = operation();
            if (result is Future) {
              GaplyHub.warning('⚠️ [Gaply] Use traceAsync for Future operations (ID: $id, Tag: $tag).');
            }
            return result;
          },
          tag: tag,
          metadata: metadata,
        )
        as T;
  }

  Future<T> traceAsync<T>(
    Future<T> Function() operation, {
    String? tag,
    Map<String, dynamic>? metadata,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final result = _runTrace<T>(() => operation().timeout(timeout), tag: tag, metadata: metadata);

    return await (result as Future<T>);
  }

  FutureOr<T> _runTrace<T>(
    FutureOr<T> Function() operation, {
    required String? tag,
    required Map<String, dynamic>? metadata,
  }) {
    if (!_canProfile) return operation();

    final nextDepth = _currentDepth + 1;
    final bool trackMem = _shouldTrackMemory;
    final sw = Stopwatch()..start();
    final int startMem = trackMem ? ProcessInfo.currentRss : 0;

    return runZoned(() {
      try {
        final result = operation();

        if (result is Future<T>) {
          return result
              .then((value) {
                _handleRecord(_buildArgs(sw, tag, nextDepth, 1, metadata), startMem, trackMem);
                return value;
              })
              .catchError((e) {
                _handleRecord(
                  _buildArgs(sw, '${tag ?? 'task'}:error', nextDepth, 1, metadata),
                  startMem,
                  trackMem,
                );
                GaplyHub.error('❌ [ASYNC ERROR] $id: $e');
                throw e;
              });
        }

        _handleRecord(_buildArgs(sw, tag, nextDepth, 0, metadata), startMem, trackMem);
        return result;
      } catch (e) {
        _handleRecord(_buildArgs(sw, '${tag ?? 'task'}:error', nextDepth, 0, metadata), startMem, trackMem);
        rethrow;
      }
    }, zoneValues: {_depthKey: nextDepth});
  }

  List<dynamic> _buildArgs(Stopwatch sw, String? tag, int depth, int async, Map<String, dynamic>? meta) {
    return [sw, id, tag, async, depth, 0, meta];
  }

  void _handleRecord(List<dynamic> args, int startMem, bool trackMem) {
    final sw = args[_Idx.sw] as Stopwatch;
    sw.stop();

    args[_Idx.sw] = sw.elapsedMicroseconds;
    args[_Idx.mem] = trackMem ? (ProcessInfo.currentRss - startMem) : 0;
    args[_Idx.tag] = GaplyUtils.cleanTag(args[_Idx.tag]);

    for (var child in _engines) {
      child.record(args);
    }
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
}

class GaplyTraceHandle {
  final List<dynamic> _args;
  final int _startMem;
  final bool _trackMemory;
  final void Function(List<dynamic> args, int startMem, bool trackMem) _onStop;

  bool _isStopped = false;

  GaplyTraceHandle._({
    required List<dynamic> args,
    required int startMem,
    required bool trackMemory,
    required void Function(List<dynamic> args, int startMem, bool trackMem) onStop,
  }) : _args = args,
       _startMem = startMem,
       _trackMemory = trackMemory,
       _onStop = onStop;

  factory GaplyTraceHandle.noOp({required String id, String? tag, Map<String, dynamic>? metadata}) {
    return GaplyTraceHandle._(args: [], startMem: 0, trackMemory: false, onStop: (_, _, _) {});
  }

  void stop({Map<String, dynamic>? extraMetadata, bool isAsync = false}) {
    if (_isStopped) return;
    _isStopped = true;

    if (isAsync) _args[_Idx.async] = 1;
    if (extraMetadata != null) {
      final base = _args[_Idx.meta] as Map<String, dynamic>?;
      _args[_Idx.meta] = base != null ? {...base, ...extraMetadata} : extraMetadata;
    }

    _onStop(_args, _startMem, _trackMemory);
  }
}

extension GaplyProfilerX on GaplyProfiler {
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

  GaplyProfiler addEngine(GaplyEngineSpec spec) {
    if (_engineExists(spec)) {
      GaplyHub.info('⚠️ [Gaply] Engine with this spec already exists: ${spec.id}');
      return this;
    }
    _engines.add(_createEngineFactory(spec));
    return this;
  }

  GaplyProfiler removeEngine(GaplyEngineSpec spec) {
    final targets = _engines.where((e) => e.spec == spec).toList();

    for (var engine in targets) {
      engine.dispose();
      _engines.remove(engine);
    }

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

abstract class _Idx {
  static const int sw = 0; // Stopwatch or Microseconds
  static const int id = 1; // Profiler ID
  static const int tag = 2; // Custom Tag
  static const int async = 3; // IsAsync Flag (0 or 1)
  static const int dep = 4; // Depth
  static const int mem = 5; // Memory Delta
  static const int meta = 6; // Metadata Map
}
