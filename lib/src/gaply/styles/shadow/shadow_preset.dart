// import 'dart:ui';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
// import 'package:gaply/src/gaply/styles/color/color_defines.dart';
//
// import 'gaply_shadow.dart';
//
// part 'shadow_preset.g.dart';
//
// @gaplyPreset
// class ShadowPreset extends GaplyPreset<GaplyShadow> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   ShadowPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     const blurColor = GaplyColor.fromToken(GaplyColorToken.shadow);
//
//     GaplyShadowPreset.add(
//       'small',
//       const GaplyShadow(spreadRadius: 0.0, blurRadius: 4.0, offset: Offset(0, 2), color: blurColor),
//     );
//     GaplyShadowPreset.add(
//       'medium',
//       const GaplyShadow(spreadRadius: -1.0, blurRadius: 10.0, offset: Offset(0, 4), color: blurColor),
//     );
//     GaplyShadowPreset.add(
//       'large',
//       const GaplyShadow(spreadRadius: -2.0, blurRadius: 24.0, offset: Offset(0, 10), color: blurColor),
//     );
//     GaplyShadowPreset.add(
//       'base',
//       const GaplyShadow(spreadRadius: 0.0, blurRadius: 5.0, offset: Offset(3, 3), color: blurColor),
//     );
//   }
// }
