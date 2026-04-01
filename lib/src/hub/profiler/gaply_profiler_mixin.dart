// import 'dart:async';
// import 'dart:isolate';
//
// import 'package:gaply/src/hub/gaply_hub.dart';
// import 'gaply_profiler_base.dart';
//
// mixin GaplyProfilerMixin<T extends GaplyProfilerStats> {
//   GaplyProfilerEngine get _self => this as GaplyProfilerEngine;
//
//   SendPort? _cachedPort;
//   Map<String, T> get statsMap;
//   int get maxKeys;
//   Duration get maxIdleTime;
//   String get category;
//   Timer? _cleanupTimer;
//
//   void initEngine(Function(ProfilePacket) onMessage) {
//     _cachedPort = GaplyHub.createEnginePort(category, (packet) {
//       if (packet is ProfilePacket) {
//         if (statsMap.length >= maxKeys) {
//           statsMap.clear();
//           _self.warningLog('⚠️ [Gaply] $category: Memory limit reached. Map cleared.');
//         }
//
//         onMessage(packet);
//       }
//     });
//
//     _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (_) {
//       _cleanupOldEntries();
//     });
//   }
//
//   void sendPacket(ProfilePacket packet) {
//     final port = _cachedPort ?? GaplyHub.getEnginePort(category);
//     port?.send(packet);
//   }
//
//   void _cleanupOldEntries() {
//     final now = DateTime.now();
//     statsMap.removeWhere((key, stats) {
//       final lastActive = stats.lastLogTime;
//       final isIdle = now.difference(lastActive) > maxIdleTime;
//       if (isIdle && stats.isNotEmpty) {
//         stats.dispose();
//       }
//       return isIdle;
//     });
//   }
//
//   void printStats(String label) {
//     statsMap.entries.where((e) => e.key.startsWith(label)).forEach((e) => e.value.printSummary(label));
//   }
//
//   Future<void> dispose() async {
//     for (var stats in statsMap.values) {
//       await stats.dispose();
//     }
//     _cleanupTimer?.cancel();
//   }
// }
