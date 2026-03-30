import 'dart:ui';

import 'color_defines.dart';
import 'gaply_color.dart';

mixin GaplyColorModifier<T> {
  GaplyColor get gaplyColor;

  T copyWithColor(GaplyColor color);

  T colorStyleSet(GaplyColor color) => copyWithColor(color);

  T colorToken(GaplyColorToken token, {double? shade, double? opacity, bool autoInvert = true}) {
    return copyWithColor(
      GaplyColor(
        token: token,
        shade: GaplyColorShade.resolve(shade),
        opacity: GaplyColorOpacity.resolve(opacity),
        autoInvert: autoInvert,
      ),
    );
  }

  T colorCustom(Color custom, {double? shade, double? opacity, bool autoInvert = true}) {
    return copyWithColor(
      GaplyColor(
        token: GaplyColorToken.none,
        customColor: custom,
        shade: GaplyColorShade.resolve(shade),
        opacity: GaplyColorOpacity.resolve(opacity),
        autoInvert: autoInvert,
      ),
    );
  }

  T colorShadeToken(GaplyColorShade shade) => copyWithColor(gaplyColor.copyWith(shade: shade));

  T colorShade(double value) => colorShadeToken(GaplyColorShade(value));

  T colorOpacityToken(GaplyColorOpacity opacity) => copyWithColor(gaplyColor.copyWith(opacity: opacity));

  T colorOpacity(double value) => colorOpacityToken(GaplyColorOpacity(value));

  T colorAutoInvert(bool value) => copyWithColor(gaplyColor.copyWith(autoInvert: value));
}

mixin GaplyBorderColorModifier<T> {
  GaplyColor get gaplyBorderColor;

  T copyWithBorderColor(GaplyColor color);

  T borderColorStyleSet(GaplyColor color) => copyWithBorderColor(color);

  T borderColorToken(GaplyColorToken token, {double? shade, double? opacity, bool autoInvert = true}) {
    return copyWithBorderColor(
      GaplyColor(
        token: token,
        shade: GaplyColorShade.resolve(shade),
        opacity: GaplyColorOpacity.resolve(opacity),
        autoInvert: autoInvert,
      ),
    );
  }

  T borderColorCustom(Color custom, {double? shade, double? opacity, bool autoInvert = true}) {
    return copyWithBorderColor(
      GaplyColor(
        token: GaplyColorToken.none,
        customColor: custom,
        shade: GaplyColorShade.resolve(shade),
        opacity: GaplyColorOpacity.resolve(opacity),
        autoInvert: autoInvert,
      ),
    );
  }

  T borderColorShadeToken(GaplyColorShade shade) =>
      copyWithBorderColor(gaplyBorderColor.copyWith(shade: shade));

  T borderColorShade(double value) => borderColorShadeToken(GaplyColorShade(value));

  T borderColorOpacityToken(GaplyColorOpacity opacity) =>
      copyWithBorderColor(gaplyBorderColor.copyWith(opacity: opacity));

  T borderColorOpacity(double value) => borderColorOpacityToken(GaplyColorOpacity(value));

  T borderColorAutoInvert(bool value) => copyWithBorderColor(gaplyBorderColor.copyWith(autoInvert: value));
}
