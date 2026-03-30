// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'color_defines.dart';
// import 'color_theme.dart';
// import 'gaply_color.dart';
//
// part 'color_theme_preset.g.dart';
//
// @gaplyPreset
// class ColorThemePreset extends GaplyPreset<GaplyColorTheme> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   ColorThemePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyColorThemePreset.add(
//       'gaply_light',
//       GaplyColorTheme(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         brightness: Brightness.light,
//         colors: {
//           GaplyColorToken.primary: GaplyColor.fromInt(0xFF00FF00),
//           GaplyColorToken.background: GaplyColor.fromInt(0xFF050505),
//           GaplyColorToken.secondary: GaplyColor.fromInt(0xFF0000FF),
//           GaplyColorToken.surface: GaplyColor.fromInt(0xFF000000),
//           GaplyColorToken.surfaceVariant: GaplyColor.fromInt(0xFF000000),
//           GaplyColorToken.error: GaplyColor.fromInt(0xFFFF0000),
//           GaplyColorToken.success: GaplyColor.fromInt(0xFF00FF00),
//           GaplyColorToken.warning: GaplyColor.fromInt(0xFFFF0000),
//           GaplyColorToken.info: GaplyColor.fromInt(0xFF0000FF),
//           GaplyColorToken.shadow: GaplyColor.fromInt(0xFF000000),
//         },
//       ),
//     );
//
//     GaplyColorThemePreset.add(
//       'gaply_dark',
//       GaplyColorTheme(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         brightness: Brightness.dark,
//         colors: {
//           GaplyColorToken.primary: GaplyColor.fromInt(0xFF00FF00),
//           GaplyColorToken.background: GaplyColor.fromInt(0xFF050505),
//           GaplyColorToken.secondary: GaplyColor.fromInt(0xFF0000FF),
//           GaplyColorToken.surface: GaplyColor.fromInt(0xFF000000),
//           GaplyColorToken.surfaceVariant: GaplyColor.fromInt(0xFF000000),
//           GaplyColorToken.error: GaplyColor.fromInt(0xFFFF0000),
//           GaplyColorToken.success: GaplyColor.fromInt(0xFF00FF00),
//           GaplyColorToken.warning: GaplyColor.fromInt(0xFFFF0000),
//           GaplyColorToken.info: GaplyColor.fromInt(0xFF0000FF),
//           GaplyColorToken.shadow: GaplyColor.fromInt(0xFF000000),
//         },
//       ),
//     );
//   }
// }
