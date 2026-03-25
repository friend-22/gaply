import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'color_ext.dart';

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
class GaplyColor extends GaplyStyle<GaplyColor> with _GColorMixin {
  final ColorRole role;
  final ColorOpacity opacity;
  final ColorShade shade;
  final Color? customColor;
  final bool autoInvert;

  const GaplyColor({
    required this.role,
    this.shade = ColorShade.s500,
    this.opacity = ColorOpacity.full,
    this.customColor,
    this.autoInvert = true,
  });

  const GaplyColor.none() : this(role: ColorRole.none);

  const GaplyColor.fromRole(
    ColorRole role, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) : this(role: role, shade: shade, opacity: opacity, autoInvert: autoInvert);

  const GaplyColor.fromColor(
    Color color, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) : this(role: ColorRole.none, customColor: color, shade: shade, opacity: opacity, autoInvert: autoInvert);

  const GaplyColor.transparent()
    : this(role: ColorRole.none, customColor: Colors.transparent, opacity: ColorOpacity.transparent);

  const GaplyColor.primary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.primary, shade: shade, opacity: opacity);

  const GaplyColor.onPrimary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.onPrimary, shade: shade, opacity: opacity);

  const GaplyColor.primaryContainer({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.primaryContainer, shade: shade, opacity: opacity);

  const GaplyColor.onPrimaryContainer({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.onPrimaryContainer, shade: shade, opacity: opacity);

  const GaplyColor.secondary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.secondary, shade: shade, opacity: opacity);

  const GaplyColor.onSecondary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.onSecondary, shade: shade, opacity: opacity);

  const GaplyColor.tertiary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.tertiary, shade: shade, opacity: opacity);

  const GaplyColor.onTertiary({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.onTertiary, shade: shade, opacity: opacity);

  const GaplyColor.error({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.error, shade: shade, opacity: opacity);

  const GaplyColor.onError({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.onError, shade: shade, opacity: opacity);

  const GaplyColor.success({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.success, shade: shade, opacity: opacity);

  const GaplyColor.warning({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.warning, shade: shade, opacity: opacity);

  const GaplyColor.surface({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.surface, shade: shade, opacity: opacity);

  const GaplyColor.surfaceVariant({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.surfaceVariant, shade: shade, opacity: opacity);

  const GaplyColor.outline({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.outline, shade: shade, opacity: opacity);

  const GaplyColor.outlineVariant({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.outlineVariant, shade: shade, opacity: opacity);

  const GaplyColor.shadow({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.shadow, shade: shade, opacity: opacity);

  const GaplyColor.scrim({ColorShade shade = ColorShade.s500, ColorOpacity opacity = ColorOpacity.full})
    : this(role: ColorRole.scrim, shade: shade, opacity: opacity);

  const GaplyColor.inverseSurface({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.inverseSurface, shade: shade, opacity: opacity);

  const GaplyColor.onInverseSurface({
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
  }) : this(role: ColorRole.onInverseSurface, shade: shade, opacity: opacity);

  const GaplyColor.subtle(ColorRole role, {ColorShade shade = ColorShade.s500})
    : this(role: role, shade: shade, opacity: ColorOpacity.subtle);

  const GaplyColor.half(ColorRole role, {ColorShade shade = ColorShade.s500})
    : this(role: role, shade: shade, opacity: ColorOpacity.half);

  const GaplyColor.solid(ColorRole role, {ColorShade shade = ColorShade.s500})
    : this(role: role, shade: shade, opacity: ColorOpacity.solid);

  @override
  bool get hasEffect => role != ColorRole.none || customColor != null;

  bool get isVisible {
    if (!hasEffect) return false;
    if (customColor == Colors.transparent) return false;
    if (opacity == ColorOpacity.transparent) return false;
    return true;
  }

  @override
  List<Object?> get props => [role, opacity, customColor, shade, autoInvert];

  @override
  GaplyColor copyWith({
    ColorRole? role,
    ColorOpacity? opacity,
    Color? customColor,
    ColorShade? shade,
    bool? autoInvert,
  }) {
    return GaplyColor(
      role: role ?? this.role,
      opacity: opacity ?? this.opacity,
      customColor: customColor ?? this.customColor,
      shade: shade ?? this.shade,
      autoInvert: autoInvert ?? this.autoInvert,
    );
  }

  @override
  GaplyColor lerp(GaplyColor? other, double t) {
    if (other == null) return this;

    final double lerpOpacityValue = lerpDouble(opacity.value, other.opacity.value, t) ?? opacity.value;
    final finalOpacity = GColorOpacityExt.fromValue(lerpOpacityValue);

    final double lerpShadeIndex =
        lerpDouble(shade.index.toDouble(), other.shade.index.toDouble(), t) ?? shade.index.toDouble();
    final finalShade = ColorShade.values[lerpShadeIndex.round().clamp(0, ColorShade.values.length - 1)];

    return GaplyColor(
      role: t < 0.5 ? role : other.role,
      opacity: finalOpacity,
      shade: finalShade,
      autoInvert: t < 0.5 ? autoInvert : other.autoInvert,
      customColor: Color.lerp(customColor, other.customColor, t),
    );
  }
}

mixin _GColorMixin {
  GaplyColor get _params => this as GaplyColor;

  Color _getMaterialColorShade(MaterialColor materialColor, bool isDark) {
    var shade = _params.shade;

    if (_params.autoInvert && isDark) {
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
    final double shadeValue = _params.shade.value;
    if (shadeValue == 0.5 && !_params.autoInvert) return color;

    final double effectiveValue = (_params.autoInvert && isDark) ? 1.0 - shadeValue : shadeValue;

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
    return switch (_params.role) {
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

  Color? resolve(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_params.role == ColorRole.none && _params.customColor == null) {
      return null;
    }

    Color baseColor = _params.customColor ?? _resolveByRole(theme.colorScheme)!;

    if (baseColor is MaterialColor) {
      baseColor = _getMaterialColorShade(baseColor, isDark);
    } else {
      baseColor = _applySmartShade(baseColor, isDark);
    }

    final alpha = _params.opacity.value;

    return baseColor.withValues(alpha: alpha);
  }
}
