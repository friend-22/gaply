import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';

import 'color_defines.dart';
import 'color_theme_modifier.dart';
import 'color_theme_preset.dart';
import 'gaply_color.dart';

part 'gaply_color_theme.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyColorTheme extends GaplyThemeData<GaplyColorTheme>
    with GaplyTweenMixin<GaplyColorTheme>, _GaplyColorThemeMixin, ColorThemeModifier<GaplyColorTheme> {
  final Map<GaplyColorToken, GaplyColor> colors;

  const GaplyColorTheme({
    super.profiler,
    Duration? duration,
    Curve? curve,
    super.onComplete,
    super.progress,
    required super.brightness,
    required this.colors,
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.easeInOut);

  // static void register(Object key, GaplyColorTheme style) => GaplyColorThemePreset.add(key, style);
  //
  // factory GaplyColorTheme.preset(Object key, {GaplyProfiler? profiler}) {
  //   final style = GaplyColorThemePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyColorThemePreset.error("GaplyColorTheme", key));
  //   }
  //   return style.copyWith(profiler: profiler);
  // }

  @override
  GaplyColorTheme copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
    Brightness? brightness,
    Map<GaplyColorToken, GaplyColor>? colors,
  }) {
    return GaplyColorTheme(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
    );
  }

  @override
  GaplyColorTheme lerp(GaplyColorTheme? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      final lerpColors = <GaplyColorToken, GaplyColor>{};
      final allKeys = {...colors.keys, ...other.colors.keys};

      for (final key in allKeys) {
        final beginColor = colors[key];
        final endColor = other.colors[key];

        if (beginColor != null && endColor != null) {
          lerpColors[key] = beginColor.lerp(endColor, t);
        } else {
          lerpColors[key] = (t < 0.5 ? beginColor : endColor) ?? const GaplyColor.none();
        }
      }

      return GaplyColorTheme(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        progress: t,
        brightness: t < 0.5 ? brightness : other.brightness,
        colors: lerpColors,
      );
    }, tag: 'lerp');
  }

  @override
  bool get hasEffect => colors.isNotEmpty;

  @override
  List<Object?> get props => [...super.props, colors];
}

mixin _GaplyColorThemeMixin {
  GaplyColorTheme get _self => this as GaplyColorTheme;
  GaplyColorTheme get colorTheme => _self;

  GaplyColorTheme copyWithColorTheme(GaplyColorTheme theme) {
    return _self.copyWith(
      profiler: theme.profiler,
      duration: theme.duration,
      curve: theme.curve,
      onComplete: theme.onComplete,
      progress: theme.progress,
      brightness: theme.brightness,
      colors: theme.colors,
    );
  }

  bool hasToken(dynamic token) {
    final resolvedToken = GaplyColorToken.resolve(token);
    return _self.colors.containsKey(resolvedToken);
  }

  GaplyColor getColor(dynamic token) {
    return _self.colors[GaplyColorToken.resolve(token)] ?? const GaplyColor.none();
  }

  Color? toColor(BuildContext context, dynamic token) {
    return _self.profiler.trace(() => getColor(token).resolve(context), tag: 'toColor');
  }
}
