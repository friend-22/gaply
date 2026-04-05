part of 'gaply_profiler.dart';

GaplyProfilerEngine _createEngineFactory(GaplyEngineSpec spec) {
  switch (spec) {
    case GaplyBatchEngineSpec s:
      return GaplyBatchEngine(spec: s);
    case GaplyMemoryEngineSpec s:
      return GaplyMemoryEngine(spec: s);
    case GaplyTraceEngineSpec s:
      return GaplyTraceEngine(spec: s);
  }

  return _GaplyNoOpEngine();
}

void workerEntryPoint(dynamic message) {
  if (message is! SendPort) return;

  final mainSendPort = message;

  ReceivePort workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  final Map<String, List<GaplyProfilerEngine>> _profilerMap = {};

  workerReceivePort.listen((data) {
    if (data is List && data.length >= 2) {
      final String id = data[0];
      final dynamic payload = data[1];
    }
  });
}

void workerListener(dynamic message) {
  if (message is! List || message.length < 2) return;
}
