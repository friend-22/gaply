// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:gaply/gaply.dart';
//
// Future<void> testParallelExplosion() async {
//   final net = GaplyHub.createProfiler(
//     id: 'NET',
//     specs: [const GaplyBatchEngineSpec(id: 'B')],
//   );
//   final img = GaplyHub.createProfiler(
//     id: 'IMG',
//     specs: [const GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.kb1)],
//   );
//   final db = GaplyHub.createProfiler(
//     id: 'DB',
//     specs: [
//       const GaplyBatchEngineSpec(id: 'B'),
//       const GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.kb1),
//     ],
//   );
//
//   print('--- 🚀 Parallel Explosion Start ---');
//   final watch = Stopwatch()..start();
//
//   // 3개의 엔진에 총 30,000개의 작업을 병렬로 주입
//   await Future.wait([
//     // 1. 네트워크: 지연 위주
//     ...List.generate(
//       10000,
//       (i) => net.traceAsync(() => Future.delayed(const Duration(milliseconds: 100)), tag: 'api_call'),
//     ),
//
//     // 2. 이미지: 메모리 폭발 위주
//     ...List.generate(
//       100,
//       (i) => img.traceAsync(() async {
//         final data = List.generate(10000, (index) => index);
//         await Future.delayed(const Duration(milliseconds: 20)); // 💡 게이트가 열릴 시간을 줌
//         return data.length;
//       }, tag: 'decode'),
//     ),
//
//     // 3. DB: 혼합형
//     ...List.generate(
//       10000,
//       (i) => db.traceAsync(() => Future.delayed(Duration(milliseconds: i % 5)), tag: 'query'),
//     ),
//   ]);
//
//   watch.stop();
//   print('--- 🏁 All 30,000 Parallel Tasks Finished in ${watch.elapsedMilliseconds}ms ---');
//
//   await Future.delayed(const Duration(milliseconds: 100));
//
//   print('--- 📊 Generating Final Report ---');
// }
//
// Future<void> testExtremeMemory() async {
//   final netProfiler = GaplyHub.createProfiler(
//     id: 'HeavyNet',
//     specs: [
//       const GaplyBatchEngineSpec(
//         id: 'Batch100',
//         threshold: GaplyBudget.fps120, // 모든 호출 기록
//         maxFlushCount: 1000,
//         maxFlushInterval: Duration(minutes: 1),
//       ),
//
//       const GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.kb1),
//     ],
//   );
//
//   final int totalCount = 100000; // 1만 건으로 점프!
//   print('--- Memory Stress Test Start: $totalCount tasks ---');
//
//   final tasks = List.generate(totalCount, (i) {
//     return netProfiler.traceAsync(() async {
//       if (i % 10 == 0) {
//         // 1000개 보낼 때마다 아주 잠깐(1ms) 쉬어서 포트가 비워질 시간을 줌
//         await Future.delayed(const Duration(milliseconds: 1));
//       }
//       return i;
//     }, tag: 'stress_task');
//   });
//
//   // 1. 발신 속도 측정
//   final watch = Stopwatch()..start();
//   await Future.wait(tasks);
//   watch.stop();
//
//   print('DEBUG: Sending $totalCount packets took ${watch.elapsedMilliseconds}ms');
//
//   // 2. 수신 및 처리 완료 대기
//   await GaplyHub.reportAll();
//
//   print('--- Memory Stress Test End ---');
// }
//
// Future<void> testHeavyHub() async {
//   print('--- Heavy Load Start ---');
//
//   final netProfiler = GaplyHub.createProfiler(
//     id: 'HeavyNet',
//     specs: [
//       const GaplyBatchEngineSpec(
//         id: 'Batch100',
//         threshold: Duration.zero, // 모든 호출 기록
//       ),
//     ],
//   );
//
//   // 1. 100개의 비동기 작업을 '동시에' 실행 (await 하지 않고 리스트에 담기)
//   final tasks = List.generate(100, (i) {
//     return netProfiler.traceAsync(() async {
//       // 각 작업마다 미세하게 다른 지연 시간 (동시성 극대화)
//       await Future.delayed(Duration(milliseconds: i % 10));
//       if (i % 2 == 0) throw Exception('Panic $i');
//       return i;
//     }, tag: 'heavy_task');
//   }).map((f) => f.catchError((_) => -1)).toList();
//
//   // 2. 모든 작업이 끝날 때까지 대기
//   await Future.wait(tasks);
//
//   print('DEBUG: All 100 traceAsync operations finished!');
//
//   // 3. [가혹한 구간] 채널에 쌓인 100개의 패킷이 소화될 때까지 flush!
//   // 만약 flush가 부실하다면 리포트의 Total Calls는 100보다 작게 나옵니다.
//
//   // 4. 리포트 출력
//   await GaplyHub.reportAll();
//   await GaplyHub.dispose();
//
//   print('--- Heavy Load End ---');
// }
//
// Future<void> testHub() async {
//   GaplyHub.info('🚀 Gaply System Initialized!');
//
//   final netProfiler = GaplyProfiler.withSpecs(
//     id: 'Network',
//     specs: [
//       const GaplyBatchEngineSpec(id: 'NetBatch', threshold: Duration(milliseconds: 500)),
//       const GaplyMemoryEngineSpec(id: 'NetMem', thresholdBytes: 1024 * 512),
//     ],
//   );
//
//   await netProfiler.traceAsync(() async {
//     GaplyHub.debug('Fetching user data from API...');
//
//     final dummyData = List.generate(1024 * 1024, (i) => i);
//
//     // 가상의 네트워크 지연 및 메모리 사용 시뮬레이션
//     await Future.delayed(const Duration(milliseconds: 700));
//
//     print('Data size: ${dummyData.length}');
//   }, tag: 'fetch_user_data');
//   print('DEBUG: traceAsync finished!');
//
//   netProfiler.printStats();
//   await netProfiler.dispose();
// }
//
// Future<void> profilerTest() async {
//   // 1. Setup Engines
//   final traceEngine = GaplyTraceEngineSpec(threshold: GaplyBudget.warning); // 8.3ms
//   final memoryEngine = GaplyMemoryEngineSpec(thresholdBytes: GaplyBudget.mb1); // 1MB
//   final batchEngine = GaplyBatchEngineSpec(
//     threshold: GaplyBudget.all,
//     maxFlushInterval: const Duration(seconds: 2),
//   );
//
//   // 2. Initialize Profilers
//   final heavyProfiler = GaplyHub.createProfiler(id: 'HeavyTask');
//   heavyProfiler.addEngine(traceEngine);
//   heavyProfiler.addEngine(memoryEngine);
//   heavyProfiler.addEngine(batchEngine);
//
//   final loopProfiler = GaplyHub.createProfiler(id: 'BatchTask').addEngine(batchEngine);
//
//   debugPrint('🚀 Starting Gaply Performance Test...\n');
//
//   // --- Test Case 1: Synchronous Heavy Task (Time & Memory) ---
//   heavyProfiler.trace(
//     () {
//       debugPrint('🧐 Running Sync Heavy Task...');
//       // Artificial Delay (~15ms)
//       final s = Stopwatch()..start();
//       while (s.elapsedMilliseconds < 15) {}
//
//       // Artificial Memory Allocation (~5MB)
//       final list = List.generate(1000000, (i) => i);
//       debugPrint('   Allocated ${list.length} integers.');
//     },
//     tag: 'InitialLoad',
//     metadata: {'type': 'MemoryHeavy', 'size': '5MB'},
//   );
//
//   // --- Test Case 2: Async Task (Time Tracking) ---
//   await heavyProfiler.traceAsync(
//     () async {
//       debugPrint('\n🌐 Running Async Network Simulation...');
//       await Future.delayed(const Duration(milliseconds: 500));
//     },
//     tag: 'ApiCall',
//     metadata: {'endpoint': '/api/v1/user_profile', 'method': 'GET', 'retry': 0},
//   );
//
//   // --- Test Case 3: Batched Loop Task (Aggregation) ---
//   debugPrint('\n🔄 Running Loop Task (Batched)...');
//   for (int i = 0; i < 50; i++) {
//     loopProfiler.trace(() {
//       // Very fast task
//       final a = 1 + i;
//     });
//     // Small gap to simulate frame intervals
//     await Future.delayed(const Duration(milliseconds: 10));
//   }
//
//   // 3. Print Final Stats
//   debugPrint('\n--- [ Final Performance Report ] ---');
//
//   // --- Test Case 4: Error Handling (Sync & Async) ---
//   debugPrint('\n⚠️ Running Error Simulation...');
//
//   // 1. Sync Error (Trace & Batch)
//   try {
//     heavyProfiler.trace(
//       () {
//         throw Exception('Critical Database Connection Failure');
//       },
//       tag: 'DB_Task',
//       metadata: {'db': 'postgres_main'},
//     );
//   } catch (e) {
//     debugPrint('   Caught expected sync error: $e');
//   }
//
//   try {
//     await heavyProfiler.traceAsync(() async {
//       await Future.delayed(const Duration(milliseconds: 100));
//       throw TimeoutException('External API Timeout');
//     }, tag: 'Auth_API');
//   } catch (e) {
//     debugPrint('   Caught expected async error: $e');
//   }
//
//   debugPrint('\n--- [ Final Performance Report ] ---');
// }
//
// // 🚀 Starting Gaply Performance Test...
// //
// // 🧐 Running Sync Heavy Task...
// // Allocated 1000000 integers.
// // [15:36:02] HeavyTask @InitialLoad :  26.755ms (160.6%)
// // [MEM] HeavyTask @InitialLoad : ++7.71 MB
// //
// // 🌐 Running Async Network Simulation...
// // [15:36:03] HeavyTask @ApiCall : 503.337ms (3021.2%)
// //
// // 🔄 Running Loop Task (Batched)...
// //
// // --- [ Final Performance Report ] ---
// // 📊 [STATS] HeavyTask
// // Budget: ✨Perf<1ms | ✅Norm<8ms | !Warn<16ms | 🚨JANK>=16.6ms
// // [Sync]  Total:1 | Avg:26.75ms | Max:26.75ms
// // Total Dist: ✨Perf:0(0.0%) | ✅Norm:0(0.0%) | !Warn:0(0.0%) | 🚨JANK:1(100.0%)
// // └ @InitialLoad: ✨Perf:0(0.0%) | ✅Norm:0(0.0%) | !Warn:0(0.0%) | 🚨JANK:1(100.0%)
// // [Async] Calls:1 | Avg:503.34ms | Max:503.34ms (Latency)
// //
// // 🧠 [MEMORY STATS] HeavyTask
// // Calls: 2 | Avg Delta: +4.15 MB | Peak: +7.71 MB | Min: 0 B
// //
// // 📦 [BATCH STATS] LoopTask : Total 0.066ms | Avg 0.001ms (50 calls)
