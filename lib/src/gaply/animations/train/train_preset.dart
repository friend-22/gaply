// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'train_style.dart';
//
// part 'train_preset.g.dart';
//
// @gaplyPreset
// class TrainPreset extends GaplyPreset<TrainStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   TrainPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyTrainPreset.add(
//       'express',
//       const TrainStyle(
//         duration: Duration(milliseconds: 400),
//         curve: Curves.easeOutExpo,
//         direction: AxisDirection.right,
//       ),
//     );
//
//     GaplyTrainPreset.add(
//       'link',
//       const TrainStyle(
//         duration: Duration(milliseconds: 600),
//         curve: Curves.easeInOutCubic,
//         direction: AxisDirection.left,
//       ),
//     );
//
//     GaplyTrainPreset.add(
//       'scenic',
//       const TrainStyle(
//         duration: Duration(milliseconds: 1200),
//         curve: Curves.linearToEaseOut,
//         direction: AxisDirection.right,
//       ),
//     );
//   }
// }
