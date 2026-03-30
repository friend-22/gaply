// import 'package:flutter/animation.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'scale_style.dart';
//
// // part 'scale_preset.g.dart';
// //
// // @gaplyPreset
// class ScalePreset extends GaplyPreset<ScaleStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   ScalePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyScalePreset.add(
//       'pressed',
//       const ScaleStyle(
//         begin: 1.0,
//         end: 0.95,
//         duration: Duration(milliseconds: 100),
//         curve: Curves.easeOutCubic,
//         isScaled: true,
//       ),
//     );
//
//     GaplyScalePreset.add(
//       'hover',
//       const ScaleStyle(
//         begin: 1.0,
//         end: 1.05,
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeOutBack,
//         isScaled: true,
//       ),
//     );
//
//     GaplyScalePreset.add(
//       'popIn',
//       const ScaleStyle(
//         begin: 0.0,
//         end: 1.0,
//         duration: Duration(milliseconds: 400),
//         curve: Curves.elasticOut,
//         isScaled: true,
//       ),
//     );
//
//     GaplyScalePreset.add(
//       'shrinkOut',
//       const ScaleStyle(
//         begin: 1.0,
//         end: 0.0,
//         duration: Duration(milliseconds: 250),
//         curve: Curves.easeInBack,
//         isScaled: true,
//       ),
//     );
//   }
// }
