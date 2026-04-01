import 'dart:ui';
import 'package:flutter/animation.dart';

import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/gaply/core/core.dart';

import 'gaply_blur_theme.dart';

mixin GaplyBlurThemeModifier<T> {
  GaplyBlurTheme get gaplyBlurTheme;

  T copyWithBlurTheme(GaplyBlurTheme theme);

  T blurThemeStyle(GaplyBlurTheme theme) => copyWithBlurTheme(theme);

  T blurThemeOf(Object key, {GaplyProfiler? profiler}) =>
      copyWithBlurTheme(GaplyBlurTheme.of(key, profiler: profiler));

  // T blurThemeUpdate(Object key, GaplyBlur color) {
  //   final resolvedRole = GaplyResolver.resolve(key);
  //   final newColors = Map<GaplyColorToken, GaplyColor>.from(gaplyColorTheme.colors);
  //   newColors[resolvedRole] = color;
  //   return copyWithBlurTheme(gaplyColorTheme.copyWith(colors: newColors));
  // }

  T blurThemeDuration(Duration duration) => copyWithBlurTheme(gaplyBlurTheme.copyWith(duration: duration));

  T blurThemeCurve(Curve curve) => copyWithBlurTheme(gaplyBlurTheme.copyWith(curve: curve));

  T blurThemeBrightness(Brightness brightness) =>
      copyWithBlurTheme(gaplyBlurTheme.copyWith(brightness: brightness));
}
