import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gaply/gaply.dart';

Future<void> testHeavyHub() async {
  print('--- Heavy Load Start ---');

  final netProfiler = GaplyHub.createProfiler(
    id: 'HeavyNet',
    specs: [
      const GaplyBatchEngineSpec(
        id: 'Batch100',
        threshold: Duration.zero, // 모든 호출 기록
      ),
    ],
  );

  // 1. 100개의 비동기 작업을 '동시에' 실행 (await 하지 않고 리스트에 담기)
  final tasks = List.generate(100, (i) {
    return netProfiler.traceAsync(() async {
      // 각 작업마다 미세하게 다른 지연 시간 (동시성 극대화)
      await Future.delayed(Duration(milliseconds: i % 10));
      return i;
    }, tag: 'heavy_task');
  });

  // 2. 모든 작업이 끝날 때까지 대기
  await Future.wait(tasks);
  print('DEBUG: All 100 traceAsync operations finished!');

  // 3. [가혹한 구간] 채널에 쌓인 100개의 패킷이 소화될 때까지 flush!
  // 만약 flush가 부실하다면 리포트의 Total Calls는 100보다 작게 나옵니다.

  await Future.delayed(Duration(seconds: 1));

  // 4. 리포트 출력
  await GaplyHub.reportAll();

  await Future.delayed(Duration(seconds: 1));

  print('--- Heavy Load End ---');
}

Future<void> testHub() async {
  const GaplyConsoleLoggerSpec(
    id: 'MainConsole',
    flushInterval: Duration(milliseconds: 100),
  ).registerDefault();

  const GaplyMemoryLoggerSpec(id: 'TempMemory', maxCapacity: 500).registerDefault();

  GaplyHub.info('🚀 Gaply System Initialized!');

  final netProfiler = GaplyProfiler.withSpecs(
    id: 'Network',
    specs: [
      const GaplyBatchEngineSpec(id: 'NetBatch', threshold: Duration(milliseconds: 500)),
      const GaplyMemoryEngineSpec(id: 'NetMem', thresholdBytes: 1024 * 512),
    ],
  );

  await netProfiler.traceAsync(
    () async {
      GaplyHub.debug('Fetching user data from API...');

      // 가상의 네트워크 지연 및 메모리 사용 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 700));
    },
    tag: 'fetch_user_data',
    metadata: {'url': 'https://api.gaply.com/user'},
  );
  print('DEBUG: traceAsync finished!');

  netProfiler.printStats();
  await netProfiler.dispose();
}

Future<void> profilerTest() async {
  const GaplyConsoleLoggerSpec().registerDefault();
  //GaplyHub.addDefaultLogger(const GaplyConsoleLoggerSpec());

  // 1. Setup Engines
  final traceEngine = GaplyTraceEngineSpec(threshold: GaplyBudget.warning); // 8.3ms
  final memoryEngine = GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.mb1); // 1MB
  final batchEngine = GaplyBatchEngineSpec(
    threshold: GaplyBudget.all,
    maxBatchInterval: const Duration(seconds: 2),
  );

  // 2. Initialize Profilers
  final heavyProfiler = GaplyHub.createProfiler(id: 'HeavyTask');
  heavyProfiler.addEngine(traceEngine);
  heavyProfiler.addEngine(memoryEngine);
  heavyProfiler.addEngine(batchEngine);

  final loopProfiler = GaplyProfiler(id: 'BatchTask').addEngine(batchEngine);

  debugPrint('🚀 Starting Gaply Performance Test...\n');

  // --- Test Case 1: Synchronous Heavy Task (Time & Memory) ---
  heavyProfiler.trace(() {
    debugPrint('🧐 Running Sync Heavy Task...');
    // Artificial Delay (~15ms)
    final s = Stopwatch()..start();
    while (s.elapsedMilliseconds < 15) {}

    // Artificial Memory Allocation (~5MB)
    final list = List.generate(1000000, (i) => i);
    debugPrint('   Allocated ${list.length} integers.');
  }, tag: 'InitialLoad');

  // --- Test Case 2: Async Task (Time Tracking) ---
  await heavyProfiler.trace(() async {
    debugPrint('\n🌐 Running Async Network Simulation...');
    await Future.delayed(const Duration(milliseconds: 500));
  }, tag: 'ApiCall');

  // --- Test Case 3: Batched Loop Task (Aggregation) ---
  debugPrint('\n🔄 Running Loop Task (Batched)...');
  for (int i = 0; i < 50; i++) {
    loopProfiler.trace(() {
      // Very fast task
      final a = 1 + i;
    });
    // Small gap to simulate frame intervals
    await Future.delayed(const Duration(milliseconds: 10));
  }

  // 3. Print Final Stats
  debugPrint('\n--- [ Final Performance Report ] ---');
  heavyProfiler.printStats();
  loopProfiler.printStats();

  GaplyHub.dispose();
}

// 🚀 Starting Gaply Performance Test...
//
// 🧐 Running Sync Heavy Task...
// Allocated 1000000 integers.
// [15:36:02] HeavyTask @InitialLoad :  26.755ms (160.6%)
// [MEM] HeavyTask @InitialLoad : ++7.71 MB
//
// 🌐 Running Async Network Simulation...
// [15:36:03] HeavyTask @ApiCall : 503.337ms (3021.2%)
//
// 🔄 Running Loop Task (Batched)...
//
// --- [ Final Performance Report ] ---
// 📊 [STATS] HeavyTask
// Budget: ✨Perf<1ms | ✅Norm<8ms | !Warn<16ms | 🚨JANK>=16.6ms
// [Sync]  Total:1 | Avg:26.75ms | Max:26.75ms
// Total Dist: ✨Perf:0(0.0%) | ✅Norm:0(0.0%) | !Warn:0(0.0%) | 🚨JANK:1(100.0%)
// └ @InitialLoad: ✨Perf:0(0.0%) | ✅Norm:0(0.0%) | !Warn:0(0.0%) | 🚨JANK:1(100.0%)
// [Async] Calls:1 | Avg:503.34ms | Max:503.34ms (Latency)
//
// 🧠 [MEMORY STATS] HeavyTask
// Calls: 2 | Avg Delta: +4.15 MB | Peak: +7.71 MB | Min: 0 B
//
// 📦 [BATCH STATS] LoopTask : Total 0.066ms | Avg 0.001ms (50 calls)
