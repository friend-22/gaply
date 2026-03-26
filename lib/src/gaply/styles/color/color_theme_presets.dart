import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'color_defines.dart';
import 'color_theme.dart';
import 'gaply_color.dart';

class GaplyColorThemePreset with GaplyPreset<GaplyColorTheme> {
  static final GaplyColorThemePreset instance = GaplyColorThemePreset._internal();
  GaplyColorThemePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'default',
      GaplyColorTheme(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        brightness: Brightness.light,
        colors: {
          GaplyColorToken.primary: GaplyColor.fromInt(0xFF00FF00),
          GaplyColorToken.background: GaplyColor.fromInt(0xFF050505),
        },
      ),
    );
  }

  static void register(String name, GaplyColorTheme style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyColorTheme? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
