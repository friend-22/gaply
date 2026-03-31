import 'package:gaply/gaply.dart';

class ProfilerBundle {
  static GaplyProfiler lightProfiler = GaplyProfiler(
    label: 'lightTheme',
    children: [
      GaplyProfiler.traceEngine(threshold: GaplyBudget.fps60),
      GaplyProfiler.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.fps60,
        maxBatchCount: 100,
      ),
      GaplyMemoryEngine(thresholdBytes: GaplyBudget.mb1),
    ],
  );

  static GaplyProfiler darkProfiler = GaplyProfiler(
    label: 'darkTheme',
    children: [
      GaplyProfiler.traceEngine(threshold: GaplyBudget.fps60),
      GaplyProfiler.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.fps60,
        maxBatchCount: 100,
      ),
      GaplyMemoryEngine(thresholdBytes: GaplyBudget.mb1),
    ],
  );

  static GaplyProfiler boxProfiler = GaplyProfiler(
    label: 'StressBox',
    children: [
      GaplyProfiler.traceEngine(threshold: GaplyBudget.fps120),
      GaplyProfiler.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.instant,
        maxBatchCount: 100,
      ),
      GaplyMemoryEngine(thresholdBytes: GaplyBudget.zeroBytes),
    ],
  );
}
