import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/color/color_defines.dart';

import 'blur_style.dart';

mixin BlurStyleModifier<T> {
  BlurStyle get blurStyle;

  T copyWithBlur(BlurStyle blur);

  T blurStyleSet(BlurStyle blur) => copyWithBlur(blur);

  T blurSigma(double value) => copyWithBlur(blurStyle.copyWith(sigma: value));

  T blurColorStyle(GaplyColor color) => copyWithBlur(blurStyle.copyWith(color: color));

  T blurColor(Color custom, {GaplyColorOpacity opacity = GaplyColorOpacity.full}) =>
      blurColorStyle(GaplyColor.fromColor(custom, opacity: opacity));

  // T blurPreset(Object name) => copyWithBlur(BlurStyle.preset(name));

  T blurIntensity(double factor) => copyWithBlur(blurStyle.copyWith(sigma: blurStyle.sigma * factor));

  T blurClear() => copyWithBlur(const BlurStyle.none());
}
