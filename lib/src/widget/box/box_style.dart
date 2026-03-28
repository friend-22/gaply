import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/utils/gaply_perf.dart';
import 'package:gaply/src/gaply/core/core.dart';
import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_presets.dart';
import 'gaply_box.dart';
import 'box_style_modifier.dart';

@immutable
class BoxStyle extends GaplyTweenStyle<BoxStyle>
    with
        GaplyTweenMixin<BoxStyle>,
        _BoxStyleMixin,
        ColorStyleModifier<BoxStyle>,
        BorderColorStyleModifier<BoxStyle>,
        LayoutStyleModifier<BoxStyle>,
        BlurStyleModifier<BoxStyle>,
        GradientStyleModifier<BoxStyle>,
        ShimmerStyleModifier<BoxStyle>,
        FilterStyleModifier<BoxStyle>,
        NoiseStyleModifier<BoxStyle>,
        ManyShadowStyleModifier<BoxStyle>,
        MotionStyleModifier<BoxStyle>,
        BoxStyleModifier<BoxStyle> {
  // 1. Layout & Shape
  final GaplyLayout layout;

  // 2. Static Style
  final GaplyColor color;
  final GaplyColor borderColor;
  final List<GaplyShadow> shadows;
  final BlurStyle blur;
  final GaplyGradient gradient;

  // 3. Dynamic Effects
  final GaplyShimmer shimmer;
  final GaplyFilter filter;
  final GaplyNoise noise;
  final GaplyMotion motion;

  // 4. button Style
  final VoidCallback? onPressed;

  const BoxStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    super.onComplete,
    super.progress,
    this.layout = const GaplyLayout.none(),
    this.color = const GaplyColor.none(),
    this.borderColor = const GaplyColor.none(),
    this.shadows = const [],
    this.blur = const BlurStyle.none(),
    this.gradient = const GaplyGradient.none(),
    this.shimmer = const GaplyShimmer.none(),
    this.filter = const GaplyFilter.none(),
    this.noise = const GaplyNoise.none(),
    this.motion = const GaplyMotion.none(),
    this.onPressed,
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.linear);

  const BoxStyle.none() : this();

  static void register(Object name, BoxStyle style) => GaplyBoxPreset.register(name, style);

  factory BoxStyle.preset(Object name, {GaplyProfiler? profiler}) {
    final style = GaplyBoxPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyBoxPreset.instance.errorMessage("BoxStyle", name));
    }
    return style.copyWith(profiler: profiler);
  }

  @override
  BoxStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
    GaplyLayout? layout,
    GaplyColor? color,
    GaplyColor? borderColor,
    double? borderWidth,
    List<GaplyShadow>? shadows,
    BlurStyle? blur,
    GaplyGradient? gradient,
    GaplyShimmer? shimmer,
    GaplyFilter? filter,
    GaplyNoise? noise,
    GaplyMotion? motion,
    VoidCallback? onPressed,
  }) {
    return BoxStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      layout: layout ?? this.layout,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      blur: blur ?? this.blur,
      gradient: gradient ?? this.gradient,
      shimmer: shimmer ?? this.shimmer,
      filter: filter ?? this.filter,
      noise: noise ?? this.noise,
      motion: motion ?? this.motion,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  BoxStyle lerp(BoxStyle? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return BoxStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        layout: layout.lerp(other.layout, t),
        color: color.lerp(other.color, t),
        borderColor: borderColor.lerp(other.borderColor, t),
        shadows: _lerpShadowList(shadows, other.shadows, t),
        blur: blur.lerp(other.blur, t),
        gradient: gradient.lerp(other.gradient, t),
        shimmer: shimmer.lerp(other.shimmer, t),
        filter: filter.lerp(other.filter, t),
        noise: noise.lerp(other.noise, t),
        motion: motion.lerp(other.motion, t),
        onPressed: t < 0.5 ? onPressed : other.onPressed,
      );
    }, tag: 'lerp');
  }

  List<GaplyShadow> _lerpShadowList(List<GaplyShadow> a, List<GaplyShadow> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return List.generate(a.length, (i) => a[i].lerp(b[i], t));
  }

  @override
  List<Object?> get props => [
    ...super.props,
    layout,
    color,
    borderColor,
    shadows,
    blur,
    gradient,
    shimmer,
    filter,
    noise,
    motion,
    onPressed,
  ];

  @override
  bool get hasEffect {
    return layout.hasEffect;
  }
}

mixin _BoxStyleMixin {
  BoxStyle get _self => this as BoxStyle;
  BoxStyle get boxStyle => _self;

  BoxStyle copyWithBox(BoxStyle box) {
    return _self.copyWith(
      profiler: box.profiler,
      duration: box.duration,
      curve: box.curve,
      onComplete: box.onComplete,
      progress: box.progress,
      layout: box.layout,
      color: box.color,
      borderColor: box.borderColor,
      shadows: box.shadows,
      blur: box.blur,
      gradient: box.gradient,
      shimmer: box.shimmer,
      filter: box.filter,
      noise: box.noise,
      motion: box.motion,
      onPressed: box.onPressed,
    );
  }

  Widget buildWidget({required Widget child}) {
    return GaplyBox(style: _self, child: child);
  }
}
