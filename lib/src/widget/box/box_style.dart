import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/core.dart';
import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_presets.dart';
import 'gaply_box.dart';
import 'box_style_modifier.dart';

@immutable
class BoxStyle extends GaplyStyle<BoxStyle>
    with
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
  final Curve curve;
  final Duration duration;

  const BoxStyle({
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
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
  });

  static void register(String name, BoxStyle style) => GaplyBoxPreset.register(name, style);

  factory BoxStyle.preset(String name) {
    final style = GaplyBoxPreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown box preset: "$name". '
        'Available presets: ${GaplyBoxPreset.instance.allKeys.join(", ")}',
      );
    }
    return style;
  }

  @override
  BoxStyle copyWithStyle(BoxStyle style) {
    return copyWith(
      layout: style.layout,
      color: style.color,
      borderColor: style.borderColor,
      shadows: style.shadows,
      blur: style.blur,
      gradient: style.gradient,
      shimmer: style.shimmer,
      filter: style.filter,
      noise: style.noise,
      motion: style.motion,
      onPressed: style.onPressed,
      duration: style.duration,
      curve: style.curve,
    );
  }

  @override
  BoxStyle copyWith({
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
    Duration? duration,
    Curve? curve,
  }) {
    return BoxStyle(
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

      // useFocusOutline: useFocusOutline ?? this.useFocusOutline,
      // focused: focused ?? this.focused,
      // center: center ?? this.center,
      onPressed: onPressed ?? this.onPressed,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  @override
  BoxStyle lerp(BoxStyle? other, double t) {
    if (other == null) return this;

    return copyWith(
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
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
    );
  }

  List<GaplyShadow> _lerpShadowList(List<GaplyShadow> a, List<GaplyShadow> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return List.generate(a.length, (i) => a[i].lerp(b[i], t));
  }

  @override
  List<Object?> get props => [
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
    duration,
    curve,
  ];

  @override
  bool get hasEffect {
    return layout.hasEffect;
  }
}

mixin _BoxStyleMixin {
  BoxStyle get boxStyle => this as BoxStyle;

  Widget buildWidget({required Widget child}) {
    return GaplyBox(style: boxStyle, child: child);
  }
}
