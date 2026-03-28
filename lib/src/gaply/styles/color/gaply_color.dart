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

  final GaplyColor? _begin;
  final GaplyColor? _end;
  final double _progress;

  const GaplyColor({
    super.profiler,
    required this.token,
    this.shade = GaplyColorShade.s500,
    this.opacity = GaplyColorOpacity.full,
    this.customColor,
    this.autoInvert = true,
  }) : _begin = null,
       _end = null,
       _progress = 1.0;

  const GaplyColor._internal({
    required super.profiler,
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

  factory GaplyColor.resolve({
    GaplyProfiler? profiler,
    required Object token,
    Object? shade,
    Object? opacity,
    Color? customColor,
    bool autoInvert = true,
  }) {
    return GaplyColor(
      profiler: profiler,
      token: GaplyColorToken.resolve(token),
      shade: GaplyColorShade.resolve(shade),
      opacity: GaplyColorOpacity.resolve(opacity),
      customColor: customColor,
      autoInvert: autoInvert,
    );
  }

  const GaplyColor.fromToken(
    GaplyColorToken token, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(profiler: profiler, token: token, shade: shade, opacity: opacity, autoInvert: autoInvert);

  const GaplyColor.fromColor(
    Color color, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(
         profiler: profiler,
         token: GaplyColorToken.none,
         customColor: color,
         shade: shade,
         opacity: opacity,
         autoInvert: autoInvert,
       );

  GaplyColor.fromInt(
    int value, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
    GaplyColorOpacity opacity = GaplyColorOpacity.full,
    bool autoInvert = true,
  }) : this(
         profiler: profiler,
         token: GaplyColorToken.none,
         customColor: Color(value),
         shade: shade,
         opacity: opacity,
         autoInvert: autoInvert,
       );

  const GaplyColor.transparent({GaplyProfiler? profiler})
    : this(
        profiler: profiler,
        token: GaplyColorToken.none,
        customColor: Colors.transparent,
        opacity: GaplyColorOpacity.transparent,
      );

  const GaplyColor.subtle(
    GaplyColorToken token, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
  }) : this(profiler: profiler, token: token, shade: shade, opacity: GaplyColorOpacity.subtle);

  const GaplyColor.half(
    GaplyColorToken token, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
  }) : this(profiler: profiler, token: token, shade: shade, opacity: GaplyColorOpacity.half);

  const GaplyColor.solid(
    GaplyColorToken token, {
    GaplyProfiler? profiler,
    GaplyColorShade shade = GaplyColorShade.s500,
  }) : this(profiler: profiler, token: token, shade: shade, opacity: GaplyColorOpacity.solid);

  @override
  GaplyColor copyWith({
    GaplyProfiler? profiler,
    dynamic token,
    dynamic opacity,
    dynamic shade,
    Color? customColor,
    bool? autoInvert,
  }) {
    return GaplyColor._internal(
      profiler: profiler ?? this.profiler,
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
    GaplyProfiler? profiler,
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
      profiler: profiler ?? this.profiler,
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

    return profiler.trace(() {
      final double lerpOpacity = lerpDouble(opacity.value, other.opacity.value, t) ?? opacity.value;
      final double lerpShade = lerpDouble(shade.value, other.shade.value, t) ?? shade.value;
      final Color? lerpColor = Color.lerp(customColor, other.customColor, t);

      return GaplyColor._internal(
        profiler: other.profiler,
        token: t < 0.5 ? token : other.token,
        opacity: GaplyColorOpacity(lerpOpacity),
        shade: GaplyColorShade(lerpShade),
        autoInvert: t < 0.5 ? autoInvert : other.autoInvert,
        customColor: lerpColor,
        begin: this,
        end: other,
        progress: t,
      );
    }, tag: 'lerp');
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

    final String hexColor = customColor != null
        ? " #${customColor!.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}"
        : "";

    final String shadeInfo = "S${(shade.value * 1000).toInt()}";

    final String opacityInfo = opacity.value < 1.0 ? " (${(opacity.value * 100).toInt()}%)" : "";

    final String progressPct = (_progress * 100).toStringAsFixed(0);

    return '🎨 [$tokenName]$hexColor ($progressPct%) ➔ $shadeInfo$opacityInfo';
  }
}

mixin _GaplyColorMixin {
  GaplyColor get _self => this as GaplyColor;
  GaplyColor get colorStyle => _self;

  GaplyColor copyWithColor(GaplyColor color) {
    return _self._copyWithInternal(
      profiler: color.profiler,
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

  static final Map<int, Color> _cacheStorage = {};
  static Brightness? _lastCachedBrightness;
  static final Map<int, Color> _materialCache = {
    for (var color in [...Colors.primaries, ...Colors.accents]) color.toARGB32(): color,
  };

  Color? resolveWithProgress(double progress, {bool isDark = false}) {
    if (!_self.hasEffect) return null;

    final start = _self._begin ?? _self;
    final finish = _self._end ?? _self;

    final GaplyColor blendedStyle = start.lerp(finish, progress);
    return _resolveColor(blendedStyle, progress);
  }

  Color? resolve(BuildContext context, {bool useCache = true}) {
    if (!_self.hasEffect) return null;

    return _self.profiler.trace(() {
      final themeData = _self.profiler.trace(
        () => GaplyTheme.maybeOf<GaplyColorTheme>(context),
        tag: 'findTheme',
      );

      final currentBrightness = themeData?.brightness ?? Theme.of(context).brightness;

      final double currentProgress = themeData?.progress ?? _self._progress;
      final bool isAnimating = currentProgress > 0.0 && currentProgress < 1.0;

      final cacheKey = Object.hash(
        _self.token,
        _self.customColor?.toARGB32(),
        (_self.shade.value * 1000).toInt(),
        (_self.opacity.value * 1000).toInt(),
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
          return cachedColor;
        }
      }

      final result = _resolveColor(_self, currentProgress);

      if (result != null && useCache && !isAnimating) {
        _cacheStorage[cacheKey] = result;
      }

      return result;
    }, tag: 'resolve');
  }

  Color? _resolveColor(GaplyColor style, double progress) {
    return _self.profiler.trace(() {
      final start = style._begin ?? style;
      final finish = style._end ?? style;

      final Color beginBase = start.customColor ?? const Color(0x00000000);
      final Color endBase = finish.customColor ?? const Color(0x00000000);

      if (progress <= 0) {
        return _resolveForBrightness(beginBase, false, style);
      }
      if (progress >= 1) {
        return _resolveForBrightness(endBase, true, style);
      }

      final Color lightResult = _resolveForBrightness(beginBase, false, style);
      final Color darkResult = _resolveForBrightness(endBase, true, style);

      return Color.lerp(lightResult, darkResult, progress);
    }, tag: '_resolveColor');
  }

  Color _resolveForBrightness(Color baseColor, bool isDark, GaplyColor style) {
    return _self.profiler.trace(() {
      Color finalColor = baseColor;

      if (finalColor is MaterialColor) {
        finalColor = _getMaterialColorShade(finalColor, isDark, style);
      } else {
        finalColor = _applySmartShade(finalColor, isDark, style);
      }

      if (style.opacity.value != 1.0) {
        finalColor = finalColor.withValues(alpha: (finalColor.a * style.opacity.value).clamp(0.0, 1.0));
      }

      return finalColor;
    }, tag: 'compute');
  }

  Color _applySmartShade(Color color, bool isDark, GaplyColor style) {
    final double base = GaplyColorShade.defaultShade.value; // 0.5
    double shade = style.shade.value;

    if (style.autoInvert && isDark) {
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

  Color _getMaterialColorShade(Color color, bool isDark, GaplyColor style) {
    Color? targetColor = color is MaterialColor ? color : _materialCache[color.toARGB32()];

    if (targetColor is MaterialColor) {
      final int index = _valueToMaterialIndex(style.shade, isDark);
      final result = targetColor[index];
      if (result != null) return result;
    }

    return _applySmartShade(targetColor ?? color, isDark, style);
  }

  int _valueToMaterialIndex(GaplyColorShade shade, bool isDark) {
    double effectiveValue = isDark ? 1.0 - shade.value : shade.value;

    if (effectiveValue <= 0.075) return 50;
    if (effectiveValue >= 0.85) return 900;

    int index = (effectiveValue * 10).round() * 100;
    return index.clamp(50, 900);
  }
}
