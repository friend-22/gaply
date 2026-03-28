import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/color_defines.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'gaply_gradient.dart';

class GaplyGradientPreset with GaplyPreset<GaplyGradient> {
  static final GaplyGradientPreset instance = GaplyGradientPreset._internal();

  GaplyGradientPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'sunset',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(token: GaplyColorToken.error),
          GaplyColor(token: GaplyColorToken.warning),
        ],
        stops: [0.0, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
    add(
      'ocean',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(token: GaplyColorToken.primary),
          GaplyColor(token: GaplyColorToken.secondary),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'forest',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(token: GaplyColorToken.secondary, shade: GaplyColorShade.s300),
          GaplyColor(token: GaplyColorToken.secondary, shade: GaplyColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'midnight',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s800),
          GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s400),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'rainbow',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor.fromColor(Colors.red),
          GaplyColor.fromColor(Colors.orange),
          GaplyColor.fromColor(Colors.yellow),
          GaplyColor.fromColor(Colors.green),
          GaplyColor.fromColor(Colors.blue),
          GaplyColor.fromColor(Colors.indigo),
          GaplyColor.fromColor(Colors.purple),
        ],
        stops: [0.0, 0.16, 0.33, 0.5, 0.67, 0.83, 1.0],
      ),
    );
    add(
      'warm',
      const GaplyGradient(
        type: GradientType.radial,
        colors: [
          GaplyColor(token: GaplyColorToken.warning, shade: GaplyColorShade.s300),
          GaplyColor(token: GaplyColorToken.warning, shade: GaplyColorShade.s600),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'cool',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(token: GaplyColorToken.primary),
          GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

  static void register(Object name, GaplyGradient style) => instance.add(name, style);

  static GaplyGradient? of(Object name) => instance.get(name);
}
