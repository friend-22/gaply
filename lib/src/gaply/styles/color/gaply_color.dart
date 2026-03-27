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

    GaplyLogger.i(
      '🎨 [GaplyColor.lerp] t: ${t.toStringAsFixed(3)} | '
      'Color: ${customColor?.toARGB32().toRadixString(16)} -> ${other.customColor?.toARGB32().toRadixString(16)} '
      '==> Result: ${lerpColor?.toARGB32().toRadixString(16)}',
      isForce: true,
    );

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

  //static final Expando<Map<int, Color>> _cacheStorage = Expando();
  static final Map<int, Color> _cacheStorage = {};
  static Brightness? _lastCachedBrightness;

  Color? resolve(BuildContext context, {bool useCache = true}) {
    if (!colorStyle.hasEffect) return null;

    if (colorStyle.customColor != null) {
      GaplyLogger.i('🌈 [ANIM_VALUE] Using lerped color: ${colorStyle.customColor}');
      return colorStyle.customColor;
    }

    final themeData = GaplyTheme.maybeOf<GaplyColorTheme>(context);
    final currentBrightness = themeData?.brightness ?? Theme.of(context).brightness;

    if (_lastCachedBrightness != null && _lastCachedBrightness != currentBrightness) {
      _cacheStorage.clear();
      GaplyLogger.i('🧹 [CACHE_CLEARED] Brightness changed: $_lastCachedBrightness -> $currentBrightness');
    }
    _lastCachedBrightness = currentBrightness;

    final bool isAnimating = colorStyle.customColor != null;

    final cacheKey = Object.hash(
      colorStyle.token,
      (colorStyle.shade.value * 1000).toInt(), // 정밀도 상향
      (colorStyle.opacity.value * 1000).toInt(),
      currentBrightness,
      // 애니메이션 중일 때는 매 프레임 변하는 색상 값 자체를 키로 사용
      isAnimating ? colorStyle.customColor!.toARGB32() : null,
    );

    if (useCache && !isAnimating && _cacheStorage.containsKey(cacheKey)) {
      GaplyLogger.i('💾 [CACHE_HIT] key: $cacheKey, color: ${_cacheStorage[cacheKey]}');
      return _cacheStorage[cacheKey];
    }

    return GaplyProfiler.traceNano('Color.resolve(${colorStyle.token.value})', () {
      final resolvedColor = _resolveImpl(context, themeData);
      GaplyLogger.i('✨ [RESOLVED] color: $resolvedColor');

      if (resolvedColor != null && useCache && !isAnimating) {
        _cacheStorage[cacheKey] = resolvedColor;
        if (isAnimating) {
          GaplyLogger.i('✨ [ANIM_RESOLVED] ${colorStyle.token.value}: $resolvedColor');
        }
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

      GaplyLogger.i(
        '🔍 [BASE_COLOR_DEBUG] Token: ${colorStyle.token.value} | '
        'BaseColor: ${baseColor?.toString()}',
      );
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

    if (shadeValue == 0.5) return color;

    return GaplyProfiler.traceNano('Color.applyShade(${colorStyle.token.value})', () {
      final double effectiveShade = (colorStyle.autoInvert && isDark) ? 1.0 - shadeValue : shadeValue;
      final hsl = HSLColor.fromColor(color);

      final double offset = 0.5 - effectiveShade;

      double newL = (hsl.lightness + offset).clamp(0.0, 1.0);
      double newS = hsl.saturation;

      newL = (newL * 1000).roundToDouble() / 1000;
      newS = (newS * 1000).roundToDouble() / 1000;

      final result = hsl.withLightness(newL).withSaturation(newS).toColor();

      GaplyLogger.i(
        '🎨 [SHADE_SUCCESS] ${colorStyle.token.value} | '
        'L: ${hsl.lightness.toStringAsFixed(3)} -> $newL | '
        'S: ${hsl.saturation.toStringAsFixed(3)} -> $newS',
      );

      return result;
    });
  }

  int _valueToMaterialIndex(double value) {
    if (value <= 0.05) return 50;
    if (value >= 0.95) return 950;
    return ((value * 10).round() * 100).clamp(100, 900);
  }
}
