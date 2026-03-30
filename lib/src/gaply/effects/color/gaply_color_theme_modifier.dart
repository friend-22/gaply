import 'dart:ui';

import 'package:flutter/animation.dart';

import 'package:gaply/src/utils/gaply_profiler.dart';
import 'color_defines.dart';
import 'gaply_color_theme.dart';
import 'gaply_color.dart';

mixin GaplyColorThemeModifier<T> {
  GaplyColorTheme get gaplyColorTheme;

  T copyWithColorTheme(GaplyColorTheme theme);

  T colorThemeStyle(GaplyColorTheme theme) => copyWithColorTheme(theme);

  T colorThemeOf(Object key, {GaplyProfiler? profiler}) =>
      copyWithColorTheme(GaplyColorTheme.of(key, profiler: profiler));

  T colorThemeUpdate(dynamic role, GaplyColor color) {
    final resolvedRole = GaplyColorToken.resolve(role);
    final newColors = Map<GaplyColorToken, GaplyColor>.from(gaplyColorTheme.colors);
    newColors[resolvedRole] = color;
    return copyWithColorTheme(gaplyColorTheme.copyWith(colors: newColors));
  }

  T colorThemeDuration(Duration duration) => copyWithColorTheme(gaplyColorTheme.copyWith(duration: duration));

  T colorThemeCurve(Curve curve) => copyWithColorTheme(gaplyColorTheme.copyWith(curve: curve));

  T colorThemeBrightness(Brightness brightness) =>
      copyWithColorTheme(gaplyColorTheme.copyWith(brightness: brightness));
}
