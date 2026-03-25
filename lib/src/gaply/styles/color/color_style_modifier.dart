import 'dart:ui';

import 'gaply_color.dart';
import 'color_ext.dart';

mixin ColorStyleModifier<T> {
  GaplyColor get colorStyle;

  T copyWithColor(GaplyColor color);

  T colorStyleSet(GaplyColor color) => copyWithColor(color);

  T colorRole(
    ColorRole role, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) => copyWithColor(GaplyColor.fromRole(role, shade: shade, opacity: opacity, autoInvert: autoInvert));

  T color(Color custom, {ColorOpacity opacity = ColorOpacity.full}) =>
      copyWithColor(GaplyColor.fromColor(custom, opacity: opacity));

  T colorShade(ColorShade shade) => copyWithColor(colorStyle.copyWith(shade: shade));

  T colorShadeValue(double value) =>
      copyWithColor(colorStyle.copyWith(shade: GColorShadeExt.fromValue(value)));

  T colorOpacity(ColorOpacity opacity) => copyWithColor(colorStyle.copyWith(opacity: opacity));

  T colorOpacityValue(double value) =>
      copyWithColor(colorStyle.copyWith(opacity: GColorOpacityExt.fromValue(value)));

  T colorAutoInvert(bool value) => copyWithColor(colorStyle.copyWith(autoInvert: value));
}
