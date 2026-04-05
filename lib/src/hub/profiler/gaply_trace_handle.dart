part of 'gaply_profiler.dart';

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

    _args[ProfilerIdx.isAsync] = isAsync ? 1 : 0;
    if (extraMetadata != null) {
      final base = _args[ProfilerIdx.metadata] as Map<String, dynamic>?;
      _args[ProfilerIdx.metadata] = base != null ? {...base, ...extraMetadata} : extraMetadata;
    }

    _onStop(_args, _startMem, _trackMemory);
  }
}
