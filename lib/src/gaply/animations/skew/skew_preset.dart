// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'skew_style.dart';
//
// part 'skew_preset.g.dart';
//
// @gaplyPreset
// class SkewPreset extends GaplyPreset<SkewStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   SkewPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplySkewPreset.add('tiltRight', SkewStyle.horizontal(0.1));
//
//     GaplySkewPreset.add('tiltUp', SkewStyle.vertical(-0.1));
//
//     GaplySkewPreset.add(
//       'bounceSkew',
//       SkewStyle.horizontal(0.2, duration: Duration(milliseconds: 600), curve: Curves.elasticOut),
//     );
//
//     GaplySkewPreset.add('flipPre', SkewStyle.horizontal(0.5, curve: Curves.easeInCubic));
//   }
// }
