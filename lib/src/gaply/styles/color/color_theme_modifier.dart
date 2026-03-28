import 'dart:ui';

import 'package:flutter/animation.dart';

import 'color_defines.dart';
import 'color_theme.dart';
import 'gaply_color.dart';

mixin ColorThemeModifier<T> {
  GaplyColorTheme get colorTheme;

  T copyWithColorTheme(GaplyColorTheme theme);

  T colorThemeStyleSet(GaplyColorTheme theme) => copyWithColorTheme(theme);

  T colorThemePreset(Object name) => copyWithColorTheme(GaplyColorTheme.preset(name));

  T colorThemeUpdate(dynamic role, GaplyColor color) {
    final resolvedRole = GaplyColorToken.resolve(role);
    final newColors = Map<GaplyColorToken, GaplyColor>.from(colorTheme.colors);
    newColors[resolvedRole] = color;
    return copyWithColorTheme(colorTheme.copyWith(colors: newColors));
  }

  T colorThemeDuration(Duration duration) => copyWithColorTheme(colorTheme.copyWith(duration: duration));

  T colorThemeCurve(Curve curve) => copyWithColorTheme(colorTheme.copyWith(curve: curve));

  T colorThemeBrightness(Brightness brightness) =>
      copyWithColorTheme(colorTheme.copyWith(brightness: brightness));
}
