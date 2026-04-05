import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gaply/src/hub/gaply_ansi.dart';

import 'package:gaply/src/hub/gaply_budget.dart';
import 'package:gaply/src/hub/gaply_hub.dart';
import 'package:gaply/src/hub/gaply_throttler.dart';

import '../isolate/gaply_isolate.dart';

part 'gaply_profiler_base.dart';
part 'gaply_engine_specs.dart';
part 'gaply_batch_engine.dart';
part 'gaply_trace_engine.dart';
part 'gaply_memory_engine.dart';
part 'gaply_trace_handle.dart';
part 'gaply_profiler_worker.dart';

class GaplyProfiler {
  final String id;
  final List<String> _engineIds;

  //final bool enabled;
  // final List<GaplyProfilerEngine> _engines;
  // final List<GaplyEngineSpec> specs;

  static const Object _depthKey = #gaply_profiler_depth;
  static final GaplyIntervalMsGate _memoryGate = GaplyIntervalMsGate();
  static GaplyWorker worker = GaplyWorkerPool.getWorker('GaplyProfiler', workerEntryPoint, workerListener);

  const GaplyProfiler.none() : id = '', _engineIds = const [];
  GaplyProfiler({
    required this.id,
    List<GaplyProfilerEngine>? engines,
    List<GaplyEngineSpec>? specs,
    required List<String> engineIds,
  }) : _engineIds = [] {
    // for (final spec in specs ?? []) {
    //   addEngine(spec);
    // }
    // for (final id in engineIds) {
    //   _engineIds.add(id);
    // }
    // for (final engine in engines ?? []) {
    //   addEngine(engine);
    // }
  }
  // GaplyProfiler({required this.id, this.enabled = true, List<GaplyProfilerEngine>? engines, List<GaplyEngineSpec>? specs}) {
  //
  // }
  //   : _engines = engines ?? [];
  //
  // GaplyProfiler.withSpecs({required this.id, this.enabled = true, required List<GaplyEngineSpec> specs})
  //   : _engines = [] {
  //   for (final spec in specs) {
  //     addEngine(spec);
  //   }
  // }

  // bool get _shouldTrackMemory => _engines.any((e) => e.spec.enableMemoryTracking);
  // bool get _canProfile => enabled && kDebugMode && _engines.isNotEmpty;

  bool get _shouldTrackMemory => false;
  bool get _canProfile => false;

  static int get _currentDepth {
    try {
      return Zone.current[_depthKey] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  GaplyTraceHandle start({String? tag, Map<String, dynamic>? metadata}) {
    if (!_canProfile) return GaplyTraceHandle.noOp(id: id, tag: tag, metadata: metadata);

    final bool trackMem = _shouldTrackMemory && _memoryGate.checkAndTick(GaplyHub.memoryTrackIntervalMs);
    final sw = Stopwatch()..start();
    final int startMem = trackMem ? ProcessInfo.currentRss : 0;

    final args = List<dynamic>.filled(7, null);
    args[ProfilerIdx.sw] = sw;
    args[ProfilerIdx.id] = id;
    args[ProfilerIdx.tag] = tag;
    args[ProfilerIdx.isAsync] = 0;
    args[ProfilerIdx.depth] = _currentDepth;
    args[ProfilerIdx.memDelta] = 0;
    args[ProfilerIdx.metadata] = metadata;

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

    final bool trackMem = _shouldTrackMemory && _memoryGate.checkAndTick(GaplyHub.memoryTrackIntervalMs);
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
                final args = _buildArgs(sw, tag, nextDepth, 1, metadata); // 태그명 유지
                args[ProfilerIdx.error] = e.toString();
                _handleRecord(args, startMem, trackMem);
                GaplyHub.error('❌ [ASYNC ERROR] $id: $e');
                throw e;
              });
        }

        _handleRecord(_buildArgs(sw, tag, nextDepth, 0, metadata), startMem, trackMem);
        return result;
      } catch (e) {
        final args = _buildArgs(sw, tag, nextDepth, 0, metadata);
        args[ProfilerIdx.error] = e.toString();
        _handleRecord(args, startMem, trackMem);
        rethrow;
      }
    }, zoneValues: {_depthKey: nextDepth});
  }

  List<dynamic> _buildArgs(Stopwatch sw, String? tag, int depth, int async, Map<String, dynamic>? metadata) {
    final args = List<dynamic>.filled(8, null);
    args[ProfilerIdx.sw] = sw;
    args[ProfilerIdx.id] = id;
    args[ProfilerIdx.tag] = tag;
    args[ProfilerIdx.isAsync] = async;
    args[ProfilerIdx.depth] = depth;
    args[ProfilerIdx.memDelta] = 0;
    args[ProfilerIdx.metadata] = metadata;
    args[ProfilerIdx.error] = null;
    return args;
  }

  void _handleRecord(List<dynamic> args, int startMem, bool trackMem) {
    final sw = args[ProfilerIdx.sw] as Stopwatch;
    sw.stop();

    args[ProfilerIdx.sw] = sw.elapsedMicroseconds;
    args[ProfilerIdx.memDelta] = trackMem ? (ProcessInfo.currentRss - startMem) : 0;

    // for (var child in _engines) {
    //   child.record(args);
    // }
  }

  Future<void> printStats() async {
    GaplyHub.info('--- [ $id - Final Performance Report ] ---', isImmediate: true);
    // for (final child in _engines) {
    //   await child.printStats(id);
    // }
  }

  Future<void> dispose() async {
    // for (final child in _engines) {
    //   await child.dispose();
    // }
  }
}

extension GaplyProfilerX on GaplyProfiler {
  // GaplyProfiler addEngine(GaplyEngineSpec spec) {
  //   if (_engineExists(spec)) {
  //     GaplyHub.info('⚠️ [Gaply] Engine with this spec already exists: ${spec.id}');
  //     return this;
  //   }
  //   //_engines.add(_createEngineFactory(spec));
  //   return this;
  //}

  // GaplyProfiler removeEngine(GaplyEngineSpec spec) {
  //   final targets = _engines.where((e) => e.spec == spec).toList();
  //
  //   for (var engine in targets) {
  //     engine.dispose();
  //     _engines.remove(engine);
  //   }
  //
  //   return this;
  // }

  // bool _engineExists(GaplyEngineSpec spec) {
  //   return _engines.any((e) {
  //     if (e.spec.id != null && spec.id != null) {
  //       return e.spec.id == spec.id;
  //     }
  //
  //     return e.spec.runtimeType == spec.runtimeType;
  //   });
  // }
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
