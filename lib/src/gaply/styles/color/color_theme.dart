import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'color_defines.dart';
import 'color_theme_modifier.dart';
import 'color_theme_presets.dart';
import 'gaply_color.dart';

class GaplyColorTheme extends GaplyThemeData<GaplyColorTheme>
    with GaplyTweenMixin<GaplyColorTheme>, _GaplyColorThemeMixin, ColorThemeModifier<GaplyColorTheme> {
  final Map<GaplyColorToken, GaplyColor> colors;

  const GaplyColorTheme({
    Duration? duration,
    Curve? curve,
    super.onComplete,
    required super.brightness,
    required this.colors,
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.easeInOut);

  static void register(String name, GaplyColorTheme style) => GaplyColorThemePreset.register(name, style);

  factory GaplyColorTheme.preset(String name) {
    final style = GaplyColorThemePreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyColorThemePreset.instance.errorMessage("GaplyColorTheme", name));
    }
    return style;
  }

  @override
  GaplyColorTheme copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Brightness? brightness,
    Map<GaplyColorToken, GaplyColor>? colors,
  }) {
    return GaplyColorTheme(
      brightness: brightness ?? this.brightness,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      colors: colors ?? this.colors,
    );
  }

  @override
  GaplyColorTheme lerp(GaplyColorTheme? other, double t) {
    if (other == null) return this;

    return GaplyProfiler.traceNano('Theme.lerp(t=${t.toStringAsFixed(2)})', () {
      final lerpColors = <GaplyColorToken, GaplyColor>{};
      final allKeys = {...colors.keys, ...other.colors.keys};

      for (final key in allKeys) {
        final beginColor = colors[key];
        final endColor = other.colors[key];

        if (beginColor != null && endColor != null) {
          GaplyLogger.i('🎨 [GaplyColor.lerp1]', isForce: true);
          lerpColors[key] = beginColor.lerp(endColor, t);
        } else {
          GaplyLogger.i('🎨 [GaplyColor.lerp2]', isForce: true);
          lerpColors[key] = (t < 0.5 ? beginColor : endColor) ?? const GaplyColor.none();
        }
      }

      return GaplyColorTheme(
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        brightness: t < 0.5 ? brightness : other.brightness,
        colors: lerpColors,
      );
    });
  }

  @override
  bool get hasEffect => colors.isNotEmpty;

  @override
  List<Object?> get props => [...super.props, ...colors.entries];
}

mixin _GaplyColorThemeMixin {
  GaplyColorTheme get colorTheme => this as GaplyColorTheme;

  GaplyColorTheme copyWithColorTheme(GaplyColorTheme theme) {
    return colorTheme.copyWith(
      duration: theme.duration,
      curve: theme.curve,
      onComplete: theme.onComplete,
      brightness: theme.brightness,
      colors: theme.colors,
    );
  }

  bool hasRole(dynamic role) {
    final resolvedRole = GaplyColorToken.resolve(role);
    return colorTheme.colors.containsKey(resolvedRole);
  }

  GaplyColor getColor(dynamic role) {
    return colorTheme.colors[GaplyColorToken.resolve(role)] ?? const GaplyColor.none();
  }

  Color? toColor(BuildContext context, dynamic role) {
    return getColor(role).resolve(context);
  }
}
