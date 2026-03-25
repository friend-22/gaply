import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/core.dart';
import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_presets.dart';
import 'gaply_box.dart';
import 'box_style_modifier.dart';

@immutable
class BoxStyle extends GaplyStyle<BoxStyle>
    with BlurStyleModifier<BoxStyle>, GradientStyleModifier<BoxStyle>, BoxStyleModifier<BoxStyle> {
  // 1. Layout & Shape
  final GaplyLayout layout;

  // 2. Static Style
  final GaplyColor color;
  final GaplyColor borderColor;
  final double borderWidth;
  final List<GaplyShadow> shadows;
  final BlurStyle blur;
  final GaplyGradient gradient;

  // 3. Dynamic Effects
  final GaplyShimmer shimmer;
  final GaplyMotion motion;

  // 4. button Style
  final VoidCallback? onPressed;
  final Curve curve;
  final Duration duration;

  const BoxStyle({
    this.layout = const GaplyLayout.none(),
    this.color = const GaplyColor.none(),
    this.borderColor = const GaplyColor.none(),
    this.borderWidth = 0.0,
    this.shadows = const [],
    this.blur = const BlurStyle.none(),
    this.gradient = const GaplyGradient.none(),
    this.shimmer = const GaplyShimmer.none(),
    this.motion = const GaplyMotion.none(),
    this.onPressed,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
  });

  static void register(String name, BoxStyle style) => GaplyBoxPreset.register(name, style);

  factory BoxStyle.preset(String name) {
    final style = GaplyBoxPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown box preset: "$name"');
    }
    return style;
  }

  @override
  bool get hasEffect {
    return layout.hasEffect;
  }

  @override
  BoxStyle get boxStyle => this;

  @override
  BoxStyle copyWithStyle(BoxStyle style) {
    return copyWith(
      layout: style.layout,
      color: style.color,
      borderColor: style.borderColor,
      borderWidth: style.borderWidth,
      shadows: style.shadows,
      blur: style.blur,
      gradient: style.gradient,
      shimmer: style.shimmer,
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
    GaplyMotion? motion,
    VoidCallback? onPressed,
    Duration? duration,
    Curve? curve,
  }) {
    if ((layout == null || layout == this.layout) &&
        (color == null || color == this.color) &&
        (borderColor == null || borderColor == this.borderColor) &&
        (borderWidth == null || borderWidth == this.borderWidth) &&
        (shadows == null || shadows == this.shadows) &&
        (blur == null || blur == this.blur) &&
        (gradient == null || gradient == this.gradient) &&
        (shimmer == null || shimmer == this.shimmer) &&
        (motion == null || motion == this.motion) &&
        (onPressed == null || onPressed == this.onPressed) &&
        (duration == null || duration == this.duration) &&
        (curve == null || curve == this.curve)) {
      return this;
    }

    return BoxStyle(
      layout: layout ?? this.layout,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadows: shadows ?? this.shadows,
      blur: blur ?? this.blur,
      gradient: gradient ?? this.gradient,
      shimmer: shimmer ?? this.shimmer,
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
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
      shadows: _lerpShadowList(shadows, other.shadows, t),
      blur: blur.lerp(other.blur, t),
      gradient: gradient.lerp(other.gradient, t),
      shimmer: shimmer.lerp(other.shimmer, t),
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
    borderWidth,
    shadows,
    blur,
    gradient,
    shimmer,
    motion,
    onPressed,
    duration,
    curve,
  ];

  Widget buildWidget({required Widget child}) {
    return GaplyBox(style: this, child: child);
  }
}
