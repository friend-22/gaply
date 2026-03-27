import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_theme.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'color_defines.dart';
import 'color_style_modifier.dart';
import 'color_theme.dart';

@immutable
class GaplyColor extends GaplyStyle<GaplyColor> with _GaplyColorMixin, ColorStyleModifier<GaplyColor> {
  final GaplyColorToken token;
  final GaplyColorOpacity opacity;
  final GaplyColorShade shade;
  final Color? customColor;
  final bool autoInvert;

  const GaplyColor({
    required this.token,
    this.shade = GaplyColorShade.s500,
    this.opacity = GaplyColorOpacity.full,
    this.customColor,
    this.autoInvert = true,
  });

  const GaplyColor.none() : this(token: GaplyColorToken.none);

  const GaplyColor.fromToken(
    GaplyColorToken token, {
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(token: token, shade: shade, opacity: opacity, autoInvert: autoInvert);

  const GaplyColor.fromColor(
    Color color, {
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(
         token: GaplyColorToken.none,
         customColor: color,
         shade: shade,
         opacity: opacity,
         autoInvert: autoInvert,
       );

  GaplyColor.fromInt(
    int value, {
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(
         token: GaplyColorToken.none,
         customColor: Color(value),
         shade: shade,
         opacity: opacity,
         autoInvert: autoInvert,
       );

  const GaplyColor.transparent()
    : this(
        token: GaplyColorToken.none,
        customColor: Colors.transparent,
        opacity: GaplyColorOpacity.transparent,
      );

  const GaplyColor.subtle(GaplyColorToken token, {GaplyColorShade shade = GaplyColorShade.s500})
    : this(token: token, shade: shade, opacity: GaplyColorOpacity.subtle);

  const GaplyColor.half(GaplyColorToken token, {GaplyColorShade shade = GaplyColorShade.s500})
    : this(token: token, shade: shade, opacity: GaplyColorOpacity.half);

  const GaplyColor.solid(GaplyColorToken token, {GaplyColorShade shade = GaplyColorShade.s500})
    : this(token: token, shade: shade, opacity: GaplyColorOpacity.solid);

  @override
  GaplyColor copyWith({dynamic token, dynamic opacity, dynamic shade, Color? customColor, bool? autoInvert}) {
    return GaplyColor(
      token: token != null ? GaplyColorToken.resolve(token) : this.token,
      opacity: opacity != null ? GaplyColorOpacity.resolve(opacity) : this.opacity,
      shade: shade != null ? GaplyColorShade.resolve(shade) : this.shade,
      customColor: customColor ?? this.customColor,
      autoInvert: autoInvert ?? this.autoInvert,
    );
  }

  @override
  GaplyColor lerp(GaplyColor? other, double t) {
    if (other == null) return this;

    final double lerpOpacity = lerpDouble(opacity.value, other.opacity.value, t) ?? opacity.value;
    final double lerpShade = lerpDouble(shade.value, other.shade.value, t) ?? shade.value;
    final Color? lerpColor = Color.lerp(customColor, other.customColor, t);

    // debugPrint(
    //   '🎨 [GaplyColor.lerp] t: ${t.toStringAsFixed(3)} | '
    //   'Color: ${customColor?.value.toRadixString(16)} -> ${other.customColor?.value.toRadixString(16)} '
    //   '==> Result: ${lerpColor?.value.toRadixString(16)}',
    // );

    return GaplyColor(
      token: t < 0.5 ? token : other.token,
      opacity: GaplyColorOpacity(lerpOpacity),
      shade: GaplyColorShade(lerpShade),
      autoInvert: t < 0.5 ? autoInvert : other.autoInvert,
      customColor: lerpColor,
    );
  }

  @override
  bool get hasEffect => token != GaplyColorToken.none || customColor != null;

  bool get isVisible {
    if (!hasEffect) return false;
    if (opacity.value < 0.001) return false;
    if (customColor != null && customColor!.a < 0.001) return false;
    return true;
  }

  @override
  List<Object?> get props => [token, opacity, customColor, shade, autoInvert];
}

mixin _GaplyColorMixin {
  GaplyColor get colorStyle => this as GaplyColor;

  GaplyColor copyWithColor(GaplyColor color) {
    return colorStyle.copyWith(
      token: color.token,
      opacity: color.opacity,
      customColor: color.customColor,
      shade: color.shade,
      autoInvert: color.autoInvert,
    );
  }

  static final Expando<Map<int, Color>> _cacheStorage = Expando();

  Color? resolve(BuildContext context, {bool useCache = true}) {
    if (!colorStyle.hasEffect) return null;

    return GaplyProfiler.trace240('Color.resolve(${colorStyle.token.value})', () {
      if (!useCache) return _resolveImpl(context);

      final themeData = GaplyTheme.maybeOf<GaplyColorTheme>(context);
      final int themeHash = themeData?.hashCode ?? 0;

      var contextCache = _cacheStorage[context] ??= {};
      final cacheKey = Object.hash(
        colorStyle.token,
        colorStyle.shade.value,
        colorStyle.opacity.value,
        themeHash,
      );

      if (contextCache.containsKey(cacheKey)) {
        return contextCache[cacheKey];
      }

      final resolvedColor = _resolveImpl(context, themeData);
      if (resolvedColor != null) {
        contextCache[cacheKey] = resolvedColor;
      }

      return resolvedColor;
    });
  }

  Color? _resolveImpl(BuildContext context, [GaplyColorTheme? themeData]) {
    final theme = themeData ?? GaplyTheme.maybeOf<GaplyColorTheme>(context);
    final isDark = (theme?.brightness ?? Theme.of(context).brightness) == Brightness.dark;

    Color? baseColor = colorStyle.customColor;
    if (baseColor == null && theme != null) {
      baseColor = theme.getColor(colorStyle.token).customColor;
    }

    if (baseColor == null) return null;

    Color shadedColor = (baseColor is MaterialColor)
        ? _getMaterialColorShade(baseColor, isDark)
        : _applySmartShade(baseColor, isDark);

    if (colorStyle.opacity.value == 1.0) return shadedColor;
    return shadedColor.withValues(alpha: colorStyle.opacity.value);
  }

  Color _getMaterialColorShade(MaterialColor materialColor, bool isDark) {
    final double shadeValue = colorStyle.shade.value;
    final double effectiveValue = (colorStyle.autoInvert && isDark) ? 1.0 - shadeValue : shadeValue;
    final int index = _valueToMaterialIndex(effectiveValue);
    if (index == 50) return materialColor.shade50;
    return materialColor[index] ?? materialColor[500]!;
  }

  Color _applySmartShade(Color color, bool isDark) {
    final double shadeValue = colorStyle.shade.value;
    if (shadeValue == 0.5 && !colorStyle.autoInvert) return color;

    final double effectiveValue = (colorStyle.autoInvert && isDark) ? 1.0 - shadeValue : shadeValue;

    final hsl = HSLColor.fromColor(color);

    if (effectiveValue < 0.5) {
      final factor = (0.5 - effectiveValue) * 2;
      return hsl.withLightness(lerpDouble(hsl.lightness, 0.95, factor)!).toColor();
    } else if (effectiveValue > 0.5) {
      final factor = (effectiveValue - 0.5) * 2;
      return hsl.withLightness(lerpDouble(hsl.lightness, 0.1, factor)!).toColor();
    }

    return color;
  }

  int _valueToMaterialIndex(double value) {
    if (value <= 0.05) return 50;
    if (value >= 0.95) return 950;
    return (value * 10).round() * 100;
  }
}
