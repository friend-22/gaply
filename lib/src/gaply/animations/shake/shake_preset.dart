// import 'package:flutter/animation.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'shake_style.dart';
//
// part 'shake_preset.g.dart';
//
// @gaplyPreset
// class ShakePreset extends GaplyPreset<ShakeStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   ShakePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyShakePreset.add(
//       'mild',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         distance: 3.0,
//         count: 2.0,
//       ),
//     );
//
//     GaplyShakePreset.add(
//       'normal',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 400),
//         curve: Curves.linear,
//         distance: 6.0,
//         count: 3.0,
//       ),
//     );
//
//     GaplyShakePreset.add(
//       'severe',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 500),
//         curve: Curves.linear,
//         distance: 10.0,
//         count: 5.0,
//       ),
//     );
//
//     GaplyShakePreset.add(
//       'alert',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.linear,
//         distance: 4.0,
//         count: 6.0,
//       ),
//     );
//
//     GaplyShakePreset.add(
//       'nod',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 350),
//         curve: Curves.easeOutCubic,
//         distance: 5.0,
//         count: 2.0,
//         isVertical: true,
//       ),
//     );
//
//     GaplyShakePreset.add(
//       'celebrate',
//       const ShakeStyle(
//         duration: Duration(milliseconds: 500),
//         curve: Curves.decelerate,
//         distance: 10.0,
//         count: 3.0,
//         isVertical: true,
//       ),
//     );
//   }
// }
