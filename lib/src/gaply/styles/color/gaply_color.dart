import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_theme.dart';

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

  final GaplyColor? _begin;
  final GaplyColor? _end;
  final double _progress;

  const GaplyColor({
    required this.token,
    this.shade = GaplyColorShade.s500,
    this.opacity = GaplyColorOpacity.full,
    this.customColor,
    this.autoInvert = true,
  }) : _begin = null,
       _end = null,
       _progress = 1.0;

  const GaplyColor._internal({
    required this.token,
    required this.shade,
    required this.opacity,
    required this.customColor,
    required this.autoInvert,
    GaplyColor? begin,
    GaplyColor? end,
    required double progress,
  }) : _begin = begin,
       _end = end,
       _progress = progress;

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
    return GaplyColor._internal(
      token: token != null ? GaplyColorToken.resolve(token) : this.token,
      opacity: opacity != null ? GaplyColorOpacity.resolve(opacity) : this.opacity,
      shade: shade != null ? GaplyColorShade.resolve(shade) : this.shade,
      customColor: customColor ?? this.customColor,
      autoInvert: autoInvert ?? this.autoInvert,
      begin: _begin,
      end: _end,
      progress: _progress,
    );
  }

  GaplyColor _copyWithInternal({
    dynamic token,
    dynamic opacity,
    dynamic shade,
    Color? customColor,
    bool? autoInvert,
    GaplyColor? begin,
    GaplyColor? end,
    double? progress,
  }) {
    return GaplyColor._internal(
      token: token != null ? GaplyColorToken.resolve(token) : this.token,
      opacity: opacity != null ? GaplyColorOpacity.resolve(opacity) : this.opacity,
      shade: shade != null ? GaplyColorShade.resolve(shade) : this.shade,
      customColor: customColor ?? this.customColor,
      autoInvert: autoInvert ?? this.autoInvert,
      begin: begin ?? _begin,
      end: end ?? _end,
      progress: progress ?? _progress,
    );
  }

  @override
  GaplyColor lerp(GaplyColor? other, double t) {
    if (other == null) return this;

    final double lerpOpacity = lerpDouble(opacity.value, other.opacity.value, t) ?? opacity.value;
    final double lerpShade = lerpDouble(shade.value, other.shade.value, t) ?? shade.value;
    final Color? lerpColor = Color.lerp(customColor, other.customColor, t);

    return GaplyColor._internal(
      token: t < 0.5 ? token : other.token,
      opacity: GaplyColorOpacity(lerpOpacity),
      shade: GaplyColorShade(lerpShade),
      autoInvert: t < 0.5 ? autoInvert : other.autoInvert,
      customColor: lerpColor,
      begin: this,
      end: other,
      progress: t,
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
  List<Object?> get props => [token, opacity, customColor, shade, autoInvert, _begin, _end, _progress];

  @override
  String toString() {
    final String tokenName = token.toString().toUpperCase();
    final String shadeInfo = "S${(shade.value * 1000).toInt()}";
    final String opacityInfo = opacity.value < 1.0 ? "(${(opacity.value * 100).toInt()}%)" : "";

    // 진행률에 따른 아이콘 표시
    String modeIcon = _progress > 0.5 ? "🌙" : "☀️";

    return '🎨 [$tokenName] $modeIcon | $shadeInfo$opacityInfo';
  }

  String toColorString(Color color, {double? progress}) {
    final String tokenName = token.toString().toUpperCase();
    final String shadeInfo = "S${(shade.value * 1000).toInt()}";
    final String opacityInfo = opacity.value < 1.0 ? "(${(opacity.value * 100).toInt()}%)" : "";

    String modeIcon = "✨";
    if (progress != null) {
      modeIcon = progress > 0.5 ? "🌙" : "☀️";
    }

    final hex = color.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0');

    return '🎨 [$tokenName] $modeIcon #$hex | $shadeInfo$opacityInfo';
  }
}

mixin _GaplyColorMixin {
  GaplyColor get colorStyle => this as GaplyColor;

  GaplyColor copyWithColor(GaplyColor color) {
    return colorStyle._copyWithInternal(
      token: color.token,
      opacity: color.opacity,
      customColor: color.customColor,
      shade: color.shade,
      autoInvert: color.autoInvert,
      begin: color._begin,
      end: color._end,
      progress: color._progress,
    );
  }

  //static final Expando<Map<int, Color>> _cacheStorage = Expando();
  static final Map<int, Color> _cacheStorage = {};
  static Brightness? _lastCachedBrightness;

  Color? resolve(BuildContext context, {bool useCache = true}) {
    if (!colorStyle.hasEffect) return null;

    final themeData = GaplyTheme.maybeOf<GaplyColorTheme>(context);
    final currentBrightness = themeData?.brightness ?? Theme.of(context).brightness;

    final double currentProgress = themeData?.progress ?? colorStyle._progress;
    final bool isAnimating = currentProgress > 0.0 && currentProgress < 1.0;

    final cacheKey = Object.hash(
      colorStyle.token,
      colorStyle.customColor?.toARGB32(),
      (colorStyle.shade.value * 1000).toInt(),
      (colorStyle.opacity.value * 1000).toInt(),
      currentBrightness,
      currentProgress == 1.0 ? 1 : 0,
    );

    if (_lastCachedBrightness != null && _lastCachedBrightness != currentBrightness) {
      _cacheStorage.clear();
    }
    _lastCachedBrightness = currentBrightness;

    if (useCache && !isAnimating && _cacheStorage.containsKey(cacheKey)) {
      final cachedColor = _cacheStorage[cacheKey];
      if (cachedColor != null) {
        // GaplyLogger.i(
        //   'Hit cachedColor: ${colorStyle.toColorString(cachedColor, progress: currentProgress)} (p:${currentProgress.toStringAsFixed(2)})',
        //   isForce: true,
        // );
        return cachedColor;
      }
    }

    final result = _resolveImpl(context, themeData);

    if (result != null && useCache && !isAnimating) {
      _cacheStorage[cacheKey] = result;
    }

    return result;
  }

  Color? _resolveImpl(BuildContext context, [GaplyColorTheme? themeData]) {
    final theme = themeData ?? GaplyTheme.maybeOf<GaplyColorTheme>(context);
    final double effectiveProgress = theme?.progress ?? colorStyle._progress;

    final start = colorStyle._begin ?? colorStyle;
    final finish = colorStyle._end ?? colorStyle;

    final Color beginBase = start.customColor ?? colorStyle.customColor ?? const Color(0x00000000);
    final Color endBase = finish.customColor ?? colorStyle.customColor ?? const Color(0x00000000);

    final Color lightResult = _resolveForBrightness(beginBase, false, colorStyle.shade);
    final Color darkResult = _resolveForBrightness(endBase, true, colorStyle.shade);

    final finalResult = Color.lerp(lightResult, darkResult, effectiveProgress);

    if (finalResult != null) {
      final String label = theme == null ? "INTERNAL" : "THEME";

      GaplyLogger.i(
        '[$label] ${colorStyle.toColorString(finalResult, progress: effectiveProgress)} (p:${effectiveProgress.toStringAsFixed(2)})',
        isForce: true,
      );
    }

    return finalResult;
  }

  Color _resolveForBrightness(Color baseColor, bool isDark, GaplyColorShade currentShade) {
    Color finalColor = baseColor;

    if (finalColor is MaterialColor) {
      finalColor = _getMaterialColorShade(finalColor, isDark, currentShade);
    } else {
      finalColor = _applySmartShade(finalColor, isDark);
    }

    if (colorStyle.opacity.value != 1.0) {
      finalColor = finalColor.withValues(alpha: (finalColor.a * colorStyle.opacity.value).clamp(0.0, 1.0));
    }

    return finalColor;
  }

  Color _applySmartShade(Color color, bool isDark) {
    final double base = GaplyColorShade.defaultShade.value; // 0.5
    double shade = colorStyle.shade.value;

    if (colorStyle.autoInvert && isDark) {
      shade = (base * 2) - shade;
    }

    if (shade == base) return color;

    if (shade < base) {
      double t = (base - shade) / base;
      return Color.lerp(color, Colors.black, t.clamp(0.0, 1.0))!;
    } else {
      double t = (shade - base) / (1.0 - base);
      return Color.lerp(color, Colors.white, t.clamp(0.0, 1.0))!;
    }
  }

  static final List<Color> _allMaterials = [...Colors.primaries, ...Colors.accents];

  Color _getMaterialColorShade(Color color, bool isDark, GaplyColorShade currentShade) {
    Color targetColor = color;

    if (targetColor is! MaterialColor) {
      try {
        targetColor = _allMaterials.firstWhere((mColor) => mColor.toARGB32() == color.toARGB32());
      } catch (_) {}
    }

    if (targetColor is MaterialColor) {
      final int index = _valueToMaterialIndex(currentShade, isDark);
      final result = targetColor[index];
      if (result != null) return result;
    }

    return _applySmartShade(targetColor, isDark);
  }

  int _valueToMaterialIndex(GaplyColorShade shade, bool isDark) {
    double effectiveValue = isDark ? 1.0 - shade.value : shade.value;

    if (effectiveValue <= 0.075) return 50;
    if (effectiveValue >= 0.85) return 900;

    int index = (effectiveValue * 10).round() * 100;
    return index.clamp(50, 900);
  }
}
