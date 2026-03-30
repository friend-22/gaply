// import 'package:flutter/animation.dart';
//
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/gaply/animations/animations.dart';
//
// // part 'motion_preset.g.dart';
// //
// // @gaplyPreset
// class MotionPreset extends GaplyPreset<GaplyMotion> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   MotionPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyMotionPreset.add(
//       'entrance',
//       const GaplyMotion(
//         animations: [
//           GaplyFadeStyle(isVisible: true, duration: Duration(milliseconds: 500)),
//           TranslateStyle(
//             begin: Offset(0, 10),
//             end: Offset.zero,
//             isMoved: true,
//             duration: Duration(milliseconds: 400),
//             curve: Curves.easeOutCubic,
//           ),
//         ],
//       ),
//     );
//
//     GaplyMotionPreset.add(
//       'pop',
//       const GaplyMotion(
//         animations: [
//           ScaleStyle(
//             begin: 0.8,
//             end: 1.0,
//             isScaled: true,
//             duration: Duration(milliseconds: 500),
//             curve: Curves.elasticOut,
//           ),
//           RotateStyle(
//             begin: -5,
//             end: 0,
//             isRotated: true,
//             duration: Duration(milliseconds: 600),
//             curve: Curves.elasticOut,
//           ),
//         ],
//       ),
//     );
//
//     GaplyMotionPreset.add(
//       'attention',
//       const GaplyMotion(
//         animations: [
//           ScaleStyle(begin: 1.0, end: 1.05, isScaled: true, duration: Duration(milliseconds: 200)),
//           ShakeStyle(duration: Duration(milliseconds: 500), distance: 4.0, count: 3.0, curve: Curves.linear),
//         ],
//       ),
//     );
//
//     GaplyMotionPreset.add(
//       'cardHover',
//       const GaplyMotion(
//         animations: [
//           TranslateStyle(
//             begin: Offset.zero,
//             end: Offset(0, -6),
//             isMoved: true,
//             duration: Duration(milliseconds: 300),
//           ),
//           ScaleStyle(begin: 1.0, end: 1.02, isScaled: true, duration: Duration(milliseconds: 300)),
//         ],
//       ),
//     );
//
//     GaplyMotionPreset.add(
//       'introAndShake',
//       GaplyMotion(
//         animations: [GaplyFadeStyle(isVisible: true, duration: const Duration(milliseconds: 400))],
//         children: [
//           const GaplyMotion(
//             animations: [ShakeStyle(distance: 2.0, count: 2.0, duration: Duration(milliseconds: 300))],
//           ),
//         ],
//       ),
//     );
//   }
// }
