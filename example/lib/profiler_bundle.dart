import 'package:gaply/gaply.dart';

class ProfilerBundle {
  static GaplyProfiler lightProfiler = GaplyProfiler(
    label: 'lightTheme',
    children: [
      GaplyHub.traceEngine(threshold: GaplyBudget.fps60),
      GaplyHub.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.fps60,
        maxBatchCount: 100,
      ),
      GaplyHub.memoryEngine(thresholdBytes: GaplyBudget.mb1),
    ],
  );

  static GaplyProfiler darkProfiler = GaplyProfiler(
    label: 'darkTheme',
    children: [
      GaplyHub.traceEngine(threshold: GaplyBudget.fps60),
      GaplyHub.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.fps60,
        maxBatchCount: 100,
      ),
      GaplyHub.memoryEngine(thresholdBytes: GaplyBudget.mb1),
    ],
  );

  static GaplyProfiler boxProfiler = GaplyProfiler(
    label: 'StressBox',
    children: [
      GaplyHub.traceEngine(threshold: GaplyBudget.fps120),
      GaplyHub.batchEngine(
        threshold: GaplyBudget.all,
        maxBatchInterval: GaplyBudget.instant,
        maxBatchCount: 100,
      ),
      GaplyHub.memoryEngine(thresholdBytes: GaplyBudget.zeroBytes),
    ],
  );
}
