import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';

import 'gaply_gradient.dart';

class GaplyGradientPreset with GaplyPreset<GaplyGradient> {
  static final GaplyGradientPreset instance = GaplyGradientPreset._internal();
  GaplyGradientPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'sunset',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(role: ColorRole.error),
          GaplyColor(role: ColorRole.warning),
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
          GaplyColor(role: ColorRole.primary),
          GaplyColor(role: ColorRole.secondary),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'forest',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(role: ColorRole.secondary, shade: ColorShade.s300),
          GaplyColor(role: ColorRole.secondary, shade: ColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'midnight',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(role: ColorRole.primary, shade: ColorShade.s800),
          GaplyColor(role: ColorRole.primary, shade: ColorShade.s400),
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
          GaplyColor(role: ColorRole.warning, shade: ColorShade.s300),
          GaplyColor(role: ColorRole.warning, shade: ColorShade.s600),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'cool',
      const GaplyGradient(
        type: GradientType.linear,
        colors: [
          GaplyColor(role: ColorRole.primary),
          GaplyColor(role: ColorRole.primary, shade: ColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

  static void register(String name, GaplyGradient style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyGradient? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
