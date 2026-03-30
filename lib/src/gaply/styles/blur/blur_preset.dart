// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
// import 'package:gaply/src/gaply/styles/color/color_defines.dart';
//
// import 'blur_style.dart';
//
// part 'blur_preset.g.dart';
//
// @gaplyPreset
// class BlurPreset extends GaplyPreset<BlurStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   BlurPreset._internal() {
//     _initDefaultPresets();
//   }
//
//   void _initDefaultPresets() {
//     const blurLowColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o10);
//     const blurMediumColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o20);
//     const blurHighColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o30);
//     const blurExtraColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o40);
//
//     GaplyBlurPreset.add('low', const BlurStyle(sigma: 4.0, color: blurLowColor));
//     GaplyBlurPreset.add('medium', const BlurStyle(sigma: 10.0, color: blurMediumColor));
//     GaplyBlurPreset.add('high', const BlurStyle(sigma: 24.0, color: blurHighColor));
//     GaplyBlurPreset.add('extra', const BlurStyle(sigma: 48.0, color: blurExtraColor));
//
//     GaplyBlurPreset.add('apple', const BlurStyle(sigma: 12.0, color: blurLowColor));
//     GaplyBlurPreset.add('windows', const BlurStyle(sigma: 20.0, color: blurLowColor));
//     GaplyBlurPreset.add('google', const BlurStyle(sigma: 25.0, color: blurLowColor));
//   }
// }
