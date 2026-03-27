import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'color_defines.dart';
import 'color_theme.dart';
import 'gaply_color.dart';

class GaplyColorThemePreset with GaplyPreset<GaplyColorTheme> {
  static final GaplyColorThemePreset instance = GaplyColorThemePreset._internal();

  GaplyColorThemePreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'test_light',
      GaplyColorTheme(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        brightness: Brightness.light,
        colors: {
          GaplyColorToken.primary: GaplyColor.fromInt(0xFF00FF00),
          GaplyColorToken.background: GaplyColor.fromInt(0xFF050505),
          GaplyColorToken.secondary: GaplyColor.fromInt(0xFF0000FF),
          GaplyColorToken.surface: GaplyColor.fromInt(0xFF000000),
          GaplyColorToken.surfaceVariant: GaplyColor.fromInt(0xFF000000),
          GaplyColorToken.error: GaplyColor.fromInt(0xFFFF0000),
          GaplyColorToken.success: GaplyColor.fromInt(0xFF00FF00),
          GaplyColorToken.warning: GaplyColor.fromInt(0xFFFF0000),
          GaplyColorToken.info: GaplyColor.fromInt(0xFF0000FF),
          GaplyColorToken.shadow: GaplyColor.fromInt(0xFF000000),
        },
      ),
    );

    add(
      'test_dark',
      GaplyColorTheme(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        brightness: Brightness.dark,
        colors: {
          GaplyColorToken.primary: GaplyColor.fromInt(0xFF00FF00),
          GaplyColorToken.background: GaplyColor.fromInt(0xFF050505),
          GaplyColorToken.secondary: GaplyColor.fromInt(0xFF0000FF),
          GaplyColorToken.surface: GaplyColor.fromInt(0xFF000000),
          GaplyColorToken.surfaceVariant: GaplyColor.fromInt(0xFF000000),
          GaplyColorToken.error: GaplyColor.fromInt(0xFFFF0000),
          GaplyColorToken.success: GaplyColor.fromInt(0xFF00FF00),
          GaplyColorToken.warning: GaplyColor.fromInt(0xFFFF0000),
          GaplyColorToken.info: GaplyColor.fromInt(0xFF0000FF),
          GaplyColorToken.shadow: GaplyColor.fromInt(0xFF000000),
        },
      ),
    );
  }

  static void register(String name, GaplyColorTheme style) => instance.add(name, style);

  static GaplyColorTheme? of(String name) => instance.get(name);
}
