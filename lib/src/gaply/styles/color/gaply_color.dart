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

    // GaplyLogger.i(
    //   '🎨 [GaplyColor.lerp] t: ${t.toStringAsFixed(3)} | '
    //   'Color: ${customColor?.toARGB32().toRadixString(16)} -> ${other.customColor?.toARGB32().toRadixString(16)} '
    //   '==> Result: ${lerpColor?.toARGB32().toRadixString(16)}',
    //   isForce: true,
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

  //static final Expando<Map<int, Color>> _cacheStorage = Expando();
  static final Map<int, Color> _cacheStorage = {};
  static Brightness? _lastCachedBrightness;

  Color? resolve(BuildContext context, {bool useCache = false}) {
    if (!colorStyle.hasEffect) return null;

    final themeData = GaplyTheme.maybeOf<GaplyColorTheme>(context);
    final currentBrightness = themeData?.brightness ?? Theme.of(context).brightness;

    final double currentProgress = themeData?.progress ?? 1.0;
    final bool isThemeAnimating = currentProgress > 0.0 && currentProgress < 1.0;
    final bool isAnimating = colorStyle.customColor != null || isThemeAnimating;

    final cacheKey = Object.hash(
      colorStyle.token,
      colorStyle.customColor,
      (colorStyle.shade.value * 1000).toInt(),
      (colorStyle.opacity.value * 1000).toInt(),
      currentBrightness,
    );

    // if (_lastCachedBrightness != null && _lastCachedBrightness != currentBrightness) {
    //   _cacheStorage.clear();
    // }
    // _lastCachedBrightness = currentBrightness;

    if (useCache && !isAnimating && _cacheStorage.containsKey(cacheKey)) {
      // GaplyLogger.i(
      //   'Cached Resolve color: ${_cacheStorage[cacheKey]?.toARGB32().toRadixString(16)}',
      //   isForce: true,
      // );

      return _cacheStorage[cacheKey];
    }

    final result = _resolveImpl(context, themeData);

    if (result != null && useCache && !isAnimating) {
      _cacheStorage[cacheKey] = result;
    }

    // GaplyLogger.i('Resolve color: ${result?.toARGB32().toRadixString(16)}', isForce: true);

    return result;
  }

  Color? _resolveImpl(BuildContext context, [GaplyColorTheme? themeData]) {
    final theme = themeData ?? GaplyTheme.maybeOf<GaplyColorTheme>(context);
    if (theme == null) return null;

    Color? baseColor = colorStyle.customColor;
    if (baseColor == null) {
      final themeStyle = theme.getColor(colorStyle.token);
      baseColor = themeStyle.customColor;
    }
    if (baseColor == null) return null;

    final beginTheme = theme.begin ?? theme;
    final endTheme = theme.end ?? theme;

    final beginStyle = beginTheme.getColor(colorStyle.token);
    final endStyle = endTheme.getColor(colorStyle.token);

    final Color beginBase = beginStyle.customColor ?? colorStyle.customColor ?? const Color(0x00000000);
    final Color endBase = endStyle.customColor ?? colorStyle.customColor ?? const Color(0x00000000);

    final Color lightResult = _resolveForBrightness(beginBase, false, colorStyle.shade);
    final Color darkResult = _resolveForBrightness(endBase, true, colorStyle.shade);

    print(
      'progress: ${theme.progress.toStringAsFixed(2)}, '
      'lightBase: ${beginBase.toARGB32().toRadixString(16)}, '
      'lightResult: ${lightResult.toARGB32().toRadixString(16)}, '
      'darkBase: ${endBase.toARGB32().toRadixString(16)}, '
      'darkResult: ${darkResult.toARGB32().toRadixString(16)}',
    );

    return Color.lerp(lightResult, darkResult, theme.progress);

    // if (colorStyle.shade.value != GaplyColorShade.defaultShade.value || colorStyle.autoInvert) {
    //   if (finalColor is MaterialColor) {
    //     finalColor = _getMaterialColorShade(finalColor, isDark);
    //   } else {
    //     finalColor = _applySmartShade(finalColor, isDark);
    //   }
    // }
    //
    // if (colorStyle.opacity.value != 1.0) {
    //   finalColor = finalColor.withValues(alpha: (finalColor.a * colorStyle.opacity.value).clamp(0.0, 1.0));
    // }
    //
    // return finalColor;
  }

  Color _resolveForBrightness(Color baseColor, bool isDark, GaplyColorShade currentShade) {
    Color finalColor = baseColor;

    if (currentShade.value != GaplyColorShade.defaultShade.value || colorStyle.autoInvert) {
      if (finalColor is MaterialColor) {
        finalColor = _getMaterialColorShade(finalColor, isDark, currentShade);
      } else {
        finalColor = _applySmartShade(finalColor, isDark);
      }
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

      print(
        'DEBUG: target=${targetColor.runtimeType}, index=${_valueToMaterialIndex(currentShade, isDark)}, shade=${currentShade.value}',
      );

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
