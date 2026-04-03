import 'package:gaply/gaply.dart';

class ProfilerBundle {
  static final traceEngine = GaplyTraceEngineSpec(threshold: GaplyBudget.fps60);
  static final batchEngine = GaplyBatchEngineSpec(
    threshold: GaplyBudget.all,
    maxFlushInterval: GaplyBudget.fps60,
    maxFlushCount: 100,
  );
  static final memoryEngine = GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.mb1);

  static GaplyProfiler lightProfiler = GaplyHub.createProfiler(
    id: 'lightTheme',
    specs: [traceEngine, memoryEngine, batchEngine],
  );
  static GaplyProfiler darkProfiler = GaplyHub.createProfiler(
    id: 'darkTheme',
    specs: [traceEngine, memoryEngine, batchEngine],
  );

  static GaplyProfiler boxProfiler = GaplyHub.createProfiler(
    id: 'StressBox',
    specs: [traceEngine, memoryEngine, batchEngine],
  );
}
