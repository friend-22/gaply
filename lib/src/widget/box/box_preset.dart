// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'package:gaply/src/gaply/effects/effects.dart';
//
// import 'box_style.dart';
//
// part 'box_preset.g.dart';
//
// @gaplyPreset
// class BoxPreset extends GaplyPreset<BoxStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   BoxPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyBoxPreset.add('rainbow', BoxStyle(gradient: GaplyGradient.preset('rainbow')));
//
//     GaplyBoxPreset.add(
//       'card',
//       const BoxStyle(
//         layout: GaplyLayout(padding: EdgeInsets.all(16), borderRadius: BorderRadius.all(Radius.circular(12))),
//         color: GaplyColor(token: GaplyColorToken.surface),
//       ),
//     );
//
//     GaplyBoxPreset.add(
//       'button',
//       const BoxStyle(
//         layout: GaplyLayout(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//         ),
//         color: GaplyColor(token: GaplyColorToken.primary),
//         duration: Duration(milliseconds: 200),
//       ),
//     );
//   }
// }
