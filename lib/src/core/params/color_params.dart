import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ColorRole {
  none,

  // 1. 핵심 브랜드 컬러 (Brand)
  primary,
  onPrimary,
  primaryContainer,
  onPrimaryContainer,

  secondary,
  onSecondary,

  tertiary,
  onTertiary,

  // 2. 상태 및 피드백 (Feedback)
  error,
  onError,

  success,
  warning,

  surface,
  onSurface,
  surfaceVariant,
  onSurfaceVariant,
  outline,
  outlineVariant,
  shadow,
  scrim,

  inverseSurface,
  onInverseSurface,
}

enum ColorOpacity {
  transparent, // 0%
  o10, // 10%
  o20, // 20%
  o30, // 30%
  o40, // 40%
  o50, // 50%
  o60, // 60%
  o70, // 70%
  o80, // 80%
  o90, // 90%
  full, // 100%
  subtle, // 12% (for UI emphasis)
  half, // 50%
  solid, // 100% (alias)
}

enum ColorShade {
  s50, // Lightest
  s100,
  s200,
  s300,
  s400,
  s500, // Default
  s600,
  s700,
  s800,
  s900,
  s950, // Darkest
}

@immutable
class ColorParams extends Equatable with _ColorParamsMixin {
  final ColorRole role;
  final ColorOpacity opacity;
  final ColorShade shade;
  final Color? customColor;
  final bool autoInvert;

  const ColorParams({
    this.role = ColorRole.none,
    this.shade = ColorShade.s500,
    this.opacity = ColorOpacity.full,
    this.customColor,
    this.autoInvert = true,
  });

  const ColorParams.transparent() : this(customColor: Colors.transparent);
  const ColorParams.primary() : this(role: ColorRole.primary, opacity: ColorOpacity.full);
  const ColorParams.onPrimary() : this(role: ColorRole.onPrimary, opacity: ColorOpacity.full);
  const ColorParams.primaryContainer() : this(role: ColorRole.primaryContainer, opacity: ColorOpacity.full);
  const ColorParams.onPrimaryContainer()
    : this(role: ColorRole.onPrimaryContainer, opacity: ColorOpacity.full);
  const ColorParams.secondary() : this(role: ColorRole.secondary, opacity: ColorOpacity.full);
  const ColorParams.onSecondary() : this(role: ColorRole.onSecondary, opacity: ColorOpacity.full);
  const ColorParams.tertiary() : this(role: ColorRole.tertiary, opacity: ColorOpacity.full);
  const ColorParams.onTertiary() : this(role: ColorRole.onTertiary, opacity: ColorOpacity.full);
  const ColorParams.error() : this(role: ColorRole.error, opacity: ColorOpacity.full);
  const ColorParams.onError() : this(role: ColorRole.onError, opacity: ColorOpacity.full);
  const ColorParams.success() : this(role: ColorRole.success, opacity: ColorOpacity.full);
  const ColorParams.warning() : this(role: ColorRole.warning, opacity: ColorOpacity.full);
  const ColorParams.surface() : this(role: ColorRole.surface, opacity: ColorOpacity.full);
  const ColorParams.surfaceVariant() : this(role: ColorRole.surfaceVariant, opacity: ColorOpacity.full);
  const ColorParams.outline() : this(role: ColorRole.outline, opacity: ColorOpacity.full);
  const ColorParams.outlineVariant() : this(role: ColorRole.outlineVariant, opacity: ColorOpacity.full);
  const ColorParams.shadow() : this(role: ColorRole.shadow, opacity: ColorOpacity.full);
  const ColorParams.scrim() : this(role: ColorRole.scrim, opacity: ColorOpacity.full);
  const ColorParams.inverseSurface() : this(role: ColorRole.inverseSurface, opacity: ColorOpacity.full);
  const ColorParams.onInverseSurface() : this(role: ColorRole.onInverseSurface, opacity: ColorOpacity.full);

  const ColorParams.subtle(ColorRole role) : this(role: role, opacity: ColorOpacity.subtle);
  const ColorParams.half(ColorRole role) : this(role: role, opacity: ColorOpacity.half);
  const ColorParams.solid(ColorRole role) : this(role: role, opacity: ColorOpacity.solid);

  bool get isVisible {
    if (customColor == Colors.transparent) return false;
    if (opacity == ColorOpacity.transparent) return false;
    if (role == ColorRole.none && customColor == null) return false;
    return true;
  }

  @override
  List<Object?> get props => [role, opacity, customColor, shade, autoInvert];

  ColorParams copyWith({
    ColorRole? role,
    ColorOpacity? opacity,
    Color? customColor,
    ColorShade? shade,
    bool? autoInvert,
  }) {
    return ColorParams(
      role: role ?? this.role,
      opacity: opacity ?? this.opacity,
      customColor: customColor ?? this.customColor,
      shade: shade ?? this.shade,
      autoInvert: autoInvert ?? this.autoInvert,
    );
  }

  ColorParams lerp(ColorParams? other, double t) {
    if (other == null) return this;

    final double lerpOpacityValue = lerpDouble(opacity.value, other.opacity.value, t) ?? opacity.value;
    final finalOpacity = ColorOpacityExtension.fromValue(lerpOpacityValue);

    final double lerpShadeIndex =
        lerpDouble(shade.index.toDouble(), other.shade.index.toDouble(), t) ?? shade.index.toDouble();
    final finalShade = ColorShade.values[lerpShadeIndex.round().clamp(0, ColorShade.values.length - 1)];

    return ColorParams(
      role: t < 0.5 ? role : other.role,
      opacity: finalOpacity,
      shade: finalShade,
      autoInvert: t < 0.5 ? autoInvert : other.autoInvert,
      customColor: Color.lerp(customColor, other.customColor, t),
    );
  }
}

mixin _ColorParamsMixin {
  ColorParams get _colorParams => this as ColorParams;

  Color _getMaterialColorShade(MaterialColor materialColor, bool isDark) {
    var shade = _colorParams.shade;

    if (_colorParams.autoInvert && isDark) {
      shade = _invertShade(shade);
    }

    return switch (shade) {
      ColorShade.s50 => materialColor.shade50,
      ColorShade.s100 => materialColor[100]!,
      ColorShade.s200 => materialColor[200]!,
      ColorShade.s300 => materialColor[300]!,
      ColorShade.s400 => materialColor[400]!,
      ColorShade.s500 => materialColor[500]!,
      ColorShade.s600 => materialColor[600]!,
      ColorShade.s700 => materialColor[700]!,
      ColorShade.s800 => materialColor[800]!,
      ColorShade.s900 => materialColor[900]!,
      ColorShade.s950 => materialColor[950] ?? materialColor[900]!,
    };
  }

  ColorShade _invertShade(ColorShade shade) {
    return ColorShade.values[ColorShade.values.length - 1 - shade.index];
  }

  Color _applySmartShade(Color color, bool isDark) {
    final double shadeValue = _colorParams.shade.value;
    if (shadeValue == 0.5 && !_colorParams.autoInvert) return color;

    final double effectiveValue = (_colorParams.autoInvert && isDark) ? 1.0 - shadeValue : shadeValue;

    final hsl = HSLColor.fromColor(color);

    if (effectiveValue < 0.5) {
      final factor = (0.5 - effectiveValue) * 2; // 0.0 ~ 1.0 (연속적)
      return hsl.withLightness(lerpDouble(hsl.lightness, 0.98, factor)!).toColor();
    } else {
      final factor = (effectiveValue - 0.5) * 2; // 0.0 ~ 1.0 (연속적)
      return hsl.withLightness(lerpDouble(hsl.lightness, 0.05, factor)!).toColor();
    }
  }

  Color? _resolveByRole(ColorScheme scheme) {
    return switch (_colorParams.role) {
      ColorRole.primary => scheme.primary,
      ColorRole.onPrimary => scheme.onPrimary,
      ColorRole.primaryContainer => scheme.primaryContainer,
      ColorRole.onPrimaryContainer => scheme.onPrimaryContainer,
      ColorRole.secondary => scheme.secondary,
      ColorRole.onSecondary => scheme.onSecondary,
      ColorRole.tertiary => scheme.tertiary,
      ColorRole.onTertiary => scheme.onTertiary,
      ColorRole.error => scheme.error,
      ColorRole.onError => scheme.onError,

      ColorRole.success => Colors.green,
      ColorRole.warning => Colors.orange,

      ColorRole.surface => scheme.surface,
      ColorRole.onSurface => scheme.onSurface,

      ColorRole.surfaceVariant => scheme.surfaceContainerHighest,
      ColorRole.onSurfaceVariant => scheme.onSurfaceVariant,

      ColorRole.outline => scheme.outline,
      ColorRole.outlineVariant => scheme.outlineVariant,

      ColorRole.shadow => scheme.shadow,
      ColorRole.scrim => scheme.scrim,

      ColorRole.inverseSurface => scheme.inverseSurface,
      ColorRole.onInverseSurface => scheme.onInverseSurface,

      ColorRole.none => null,
    };
  }

  Color resolve(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color baseColor = _colorParams.customColor ?? _resolveByRole(theme.colorScheme) ?? Colors.transparent;

    if (baseColor is MaterialColor) {
      baseColor = _getMaterialColorShade(baseColor, isDark);
    } else {
      baseColor = _applySmartShade(baseColor, isDark);
    }

    final alpha = _colorParams.opacity.value;

    return baseColor.withValues(alpha: alpha);
  }
}

extension ColorParamsQuickX on ColorParams {
  ColorParams opacity(ColorOpacity newOpacity) => copyWith(opacity: newOpacity);
  ColorParams opacityValue(double value) => copyWith(opacity: ColorOpacityExtension.fromValue(value));
  ColorParams shade(ColorShade newShade) => copyWith(shade: newShade);
  ColorParams shadeValue(double value) => copyWith(shade: ColorShadeExtension.fromValue(value));
}

extension ColorParamsLerpX on ColorParams {
  static Color? lerpResult(BuildContext context, ColorParams? a, ColorParams? b, double t) {
    final colorA = a?.resolve(context);
    final colorB = b?.resolve(context);
    return Color.lerp(colorA, colorB, t);
  }
}

extension ColorOpacityExtension on ColorOpacity {
  double get value => switch (this) {
    ColorOpacity.transparent => 0.0,
    ColorOpacity.o10 => 0.1,
    ColorOpacity.o20 => 0.2,
    ColorOpacity.o30 => 0.3,
    ColorOpacity.o40 => 0.4,
    ColorOpacity.o50 => 0.5,
    ColorOpacity.o60 => 0.6,
    ColorOpacity.o70 => 0.7,
    ColorOpacity.o80 => 0.8,
    ColorOpacity.o90 => 0.9,
    ColorOpacity.full || ColorOpacity.solid => 1.0,
    ColorOpacity.subtle => 0.12,
    ColorOpacity.half => 0.5,
  };

  static ColorOpacity fromValue(double val) {
    return ColorOpacity.values.reduce((a, b) => (a.value - val).abs() < (b.value - val).abs() ? a : b);
  }
}

extension ColorShadeExtension on ColorShade {
  double get value => switch (this) {
    ColorShade.s50 => 0.05,
    ColorShade.s100 => 0.1,
    ColorShade.s200 => 0.2,
    ColorShade.s300 => 0.3,
    ColorShade.s400 => 0.4,
    ColorShade.s500 => 0.5,
    ColorShade.s600 => 0.6,
    ColorShade.s700 => 0.7,
    ColorShade.s800 => 0.8,
    ColorShade.s900 => 0.9,
    ColorShade.s950 => 0.95,
  };

  static ColorShade fromValue(double val) {
    return ColorShade.values.reduce((a, b) => (a.value - val).abs() < (b.value - val).abs() ? a : b);
  }
}
