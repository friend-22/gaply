import 'package:flutter/widgets.dart';

import 'gaply_color.dart';

extension GColorExtLerp on GaplyColor {
  static Color? lerpResult(BuildContext context, GaplyColor? a, GaplyColor? b, double t) {
    final colorA = a?.resolve(context);
    final colorB = b?.resolve(context);
    return Color.lerp(colorA, colorB, t);
  }
}

extension GColorOpacityExt on ColorOpacity {
  double get value => switch (this) {
    ColorOpacity.transparent => 0.0,
    ColorOpacity.o10 => 0.1,
    ColorOpacity.o20 => 0.2,
    ColorOpacity.o30 => 0.3,
    ColorOpacity.o40 => 0.4,
    ColorOpacity.o50 => 0.5,
    ColorOpacity.o60 => 0.6,
    ColorOpacity.o70 => 0.7,
    ColorOpacity.o80 => 0.8,
    ColorOpacity.o90 => 0.9,
    ColorOpacity.full || ColorOpacity.solid => 1.0,
    ColorOpacity.subtle => 0.12,
    ColorOpacity.half => 0.5,
  };

  static ColorOpacity fromValue(double val) {
    return ColorOpacity.values.reduce((a, b) => (a.value - val).abs() < (b.value - val).abs() ? a : b);
  }
}

extension GColorShadeExt on ColorShade {
  double get value => switch (this) {
    ColorShade.s50 => 0.05,
    ColorShade.s100 => 0.1,
    ColorShade.s200 => 0.2,
    ColorShade.s300 => 0.3,
    ColorShade.s400 => 0.4,
    ColorShade.s500 => 0.5,
    ColorShade.s600 => 0.6,
    ColorShade.s700 => 0.7,
    ColorShade.s800 => 0.8,
    ColorShade.s900 => 0.9,
    ColorShade.s950 => 0.95,
  };

  static ColorShade fromValue(double val) {
    return ColorShade.values.reduce((a, b) => (a.value - val).abs() < (b.value - val).abs() ? a : b);
  }
}
