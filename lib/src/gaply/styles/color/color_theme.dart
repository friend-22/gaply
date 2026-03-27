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
    super.progress,
    super.begin,
    super.end,
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
    double? progress,
    Brightness? brightness,
    GaplyColorTheme? begin,
    GaplyColorTheme? end,
    Map<GaplyColorToken, GaplyColor>? colors,
  }) {
    return GaplyColorTheme(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
      begin: begin ?? this.begin,
      end: end ?? this.end,
    );
  }

  @override
  GaplyColorTheme lerp(GaplyColorTheme? other, double t) {
    if (other == null) return this;

    return GaplyProfiler.trace240('Theme.lerp(t=${t.toStringAsFixed(2)})', () {
      // final lerpColors = <GaplyColorToken, GaplyColor>{};
      // final allKeys = {...colors.keys, ...other.colors.keys};
      //
      // for (final key in allKeys) {
      //   final beginColor = colors[key];
      //   final endColor = other.colors[key];
      //
      //   if (beginColor != null && endColor != null) {
      //     lerpColors[key] = beginColor.lerp(endColor, t);
      //   } else {
      //     lerpColors[key] = (t < 0.5 ? beginColor : endColor) ?? const GaplyColor.none();
      //   }
      // }

      return GaplyColorTheme(
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        progress: t,
        brightness: t < 0.5 ? brightness : other.brightness,
        colors: other.colors,
        begin: this,
        end: other,
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
      progress: theme.progress,
      brightness: theme.brightness,
      colors: theme.colors,
      begin: theme.begin,
      end: theme.end,
    );
  }

  bool hasToken(dynamic token) {
    final resolvedToken = GaplyColorToken.resolve(token);
    return colorTheme.colors.containsKey(resolvedToken);
  }

  GaplyColor getColor(dynamic token) {
    return colorTheme.colors[GaplyColorToken.resolve(token)] ?? const GaplyColor.none();
  }

  Color? toColor(BuildContext context, dynamic token) {
    return getColor(token).resolve(context);
  }
}
