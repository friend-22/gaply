import 'package:flutter/material.dart';

import 'package:gaply/src/inner_gaply_base.dart';

import 'gaply_blur.dart';
import 'gaply_blur_theme_modifier.dart';

part 'gaply_blur_theme.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyBlurTheme extends GaplyThemeData<GaplyBlurTheme>
    with GaplyTweenMixin<GaplyBlurTheme>, _GaplyBlurThemeMixin, GaplyBlurThemeModifier<GaplyBlurTheme> {
  final Map<Object, GaplyBlur> blurs;

  const GaplyBlurTheme({
    super.profiler,
    Duration? duration,
    Curve? curve,
    super.onComplete,
    super.progress,
    required super.brightness,
    required this.blurs,
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.easeInOut);

  static GaplyBlurThemePreset preset = GaplyBlurThemePreset._i;

  factory GaplyBlurTheme.of(Object key, {GaplyProfiler? profiler}) {
    final style = preset.get(key);
    if (style == null) throw ArgumentError(preset.error(key));
    return style.copyWith(profiler: profiler);
  }

  @override
  GaplyBlurTheme copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
    Brightness? brightness,
    Map<Object, GaplyBlur>? blurs,
  }) {
    return GaplyBlurTheme(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      brightness: brightness ?? this.brightness,
      blurs: blurs ?? this.blurs,
    );
  }

  @override
  GaplyBlurTheme lerp(GaplyBlurTheme? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      final lerpBlurs = <Object, GaplyBlur>{};
      final allKeys = {...blurs.keys, ...other.blurs.keys};

      for (final key in allKeys) {
        final beginBlur = blurs[key];
        final endBlur = other.blurs[key];

        if (beginBlur != null && endBlur != null) {
          lerpBlurs[key] = beginBlur.lerp(endBlur, t);
        } else {
          lerpBlurs[key] = (t < 0.5 ? beginBlur : endBlur) ?? const GaplyBlur.none();
        }
      }

      return GaplyBlurTheme(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        progress: t,
        brightness: t < 0.5 ? brightness : other.brightness,
        blurs: lerpBlurs,
      );
    }, tag: 'lerp');
  }

  @override
  bool get hasEffect => blurs.values.any((b) => b.hasEffect);

  @override
  List<Object?> get props => [...super.props, blurs];
}

mixin _GaplyBlurThemeMixin {
  GaplyBlurTheme get _self => this as GaplyBlurTheme;
  GaplyBlurTheme get gaplyBlurTheme => _self;

  GaplyBlurTheme copyWithBlurTheme(GaplyBlurTheme theme) {
    return _self.copyWith(
      profiler: theme.profiler,
      duration: theme.duration,
      curve: theme.curve,
      onComplete: theme.onComplete,
      progress: theme.progress,
      brightness: theme.brightness,
      blurs: theme.blurs,
    );
  }

  GaplyBlur getBlur(Object key) {
    return _self.blurs[key] ?? const GaplyBlur.none();
  }
}

void _initPresets(GaplyBlurThemePreset preset) {
  preset.add(
    'light',
    GaplyBlurTheme(
      brightness: Brightness.light,
      blurs: {'surface': const GaplyBlur(sigma: 10.0), 'overlay': const GaplyBlur(sigma: 20.0)},
    ),
  );

  preset.add(
    'dark',
    GaplyBlurTheme(
      brightness: Brightness.dark,
      blurs: {'surface': const GaplyBlur(sigma: 15.0), 'overlay': const GaplyBlur(sigma: 30.0)},
    ),
  );
}
