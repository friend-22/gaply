// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'translate_style.dart';
//
// part 'translate_preset.g.dart';
//
// @gaplyPreset
// class TranslatePreset extends GaplyPreset<TranslateStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   TranslatePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyTranslatePreset.add(
//       'push',
//       const TranslateStyle(
//         begin: Offset.zero,
//         end: Offset(0, 2),
//         duration: Duration(milliseconds: 100),
//         curve: Curves.easeOutQuad,
//         isMoved: true,
//       ),
//     );
//
//     GaplyTranslatePreset.add(
//       'float',
//       const TranslateStyle(
//         begin: Offset.zero,
//         end: Offset(0, -4),
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOutCubic,
//         isMoved: true,
//       ),
//     );
//
//     GaplyTranslatePreset.add(
//       'nudge',
//       const TranslateStyle(
//         begin: Offset.zero,
//         end: Offset(6, 0),
//         duration: Duration(milliseconds: 250),
//         curve: Curves.easeOutBack,
//         isMoved: true,
//       ),
//     );
//
//     GaplyTranslatePreset.add(
//       'rise',
//       const TranslateStyle(
//         begin: Offset(0, 10),
//         end: Offset.zero,
//         duration: Duration(milliseconds: 400),
//         curve: Curves.decelerate,
//         isMoved: true,
//       ),
//     );
//   }
// }
