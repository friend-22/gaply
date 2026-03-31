import 'package:flutter/material.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';

import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'package:gaply/src/gaply/effects/color/color_defines.dart';

import 'gaply_blur.dart';

mixin GaplyBlurModifier<T> {
  GaplyBlur get gaplyBlur;

  T copyWithBlur(GaplyBlur blur);

  T blurStyle(GaplyBlur blur) => copyWithBlur(blur);

  T blurOf(Object key, {GaplyProfiler? profiler, GaplyColor? color}) =>
      copyWithBlur(GaplyBlur.of(key, profiler: profiler, color: color));

  T blurSigma(double value) => copyWithBlur(gaplyBlur.copyWith(sigma: value));

  T blurColorStyle(GaplyColor color) => copyWithBlur(gaplyBlur.copyWith(color: color));

  T blurColor(Color custom, {GaplyColorOpacity opacity = GaplyColorOpacity.full}) =>
      blurColorStyle(GaplyColor.fromColor(custom, opacity: opacity));

  T blurIntensity(double factor) => copyWithBlur(gaplyBlur.copyWith(sigma: gaplyBlur.sigma * factor));

  T blurClear() => copyWithBlur(const GaplyBlur.none());
}
