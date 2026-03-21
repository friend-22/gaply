import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/shadow_params.dart';
import 'package:gaply/src/core/params/shimmer_params.dart';
import 'package:gaply/src/widget/tap_gesture_detector.dart';

import 'animation_sequence_params.dart';
import 'blur_params.dart';
import 'color_params.dart';
import 'gradient_params.dart';

enum BoxType { none, box }

@immutable
class BoxParams extends ParamsBase<BoxParams> {
  final BoxType boxType;

  // 1. Layout & Shape
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;

  // 2. Static Style
  final ColorParams color;
  final ColorParams borderColor;
  final double borderWidth;
  final List<ShadowParams> shadows;
  final BlurParams blur;
  final GradientParams gradient;

  // 3. Dynamic Effects
  final ShimmerParams shimmer;
  final AnimationSequenceParams animation;

  // 4. button Style
  final VoidCallback? onPressed;
  final Curve curve;
  final Duration duration;

  const BoxParams({
    this.boxType = BoxType.box,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.alignment,
    this.color = const ColorParams.transparent(),
    this.borderColor = const ColorParams.transparent(),
    this.borderWidth = 0.0,
    this.shadows = const [],
    this.blur = const BlurParams(),
    this.gradient = const GradientParams(colors: [], stops: []),
    this.shimmer = const ShimmerParams(),
    this.animation = const AnimationSequenceParams(),
    this.onPressed,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
  });

  factory BoxParams.preset(String name) {
    return GaplyBoxPreset.of(name) ?? const BoxParams();
  }

  @override
  bool get isEnabled => true;

  @override
  BoxParams copyWith({
    BoxType? boxType,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
    ColorParams? color,
    ColorParams? borderColor,
    double? borderWidth,
    List<ShadowParams>? shadows,
    BlurParams? blur,
    GradientParams? gradient,
    ShimmerParams? shimmer,
    AnimationSequenceParams? animation,
    VoidCallback? onPressed,
    Duration? duration,
    Curve? curve,
  }) {
    return BoxParams(
      boxType: boxType ?? this.boxType,
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      alignment: alignment ?? this.alignment,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadows: shadows ?? this.shadows,
      blur: blur ?? this.blur,
      gradient: gradient ?? this.gradient,
      shimmer: shimmer ?? this.shimmer,
      animation: animation ?? this.animation,

      // useFocusOutline: useFocusOutline ?? this.useFocusOutline,
      // focused: focused ?? this.focused,
      // center: center ?? this.center,
      onPressed: onPressed ?? this.onPressed,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  @override
  BoxParams lerp(BoxParams? other, double t) {
    if (other == null) return this;
    return copyWith(
      boxType: t < 0.5 ? boxType : other.boxType,
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      borderRadius: BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      color: color.lerp(other.color, t),
      borderColor: borderColor.lerp(other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
      shadows: _lerpShadowList(shadows, other.shadows, t),
      blur: blur.lerp(other.blur, t),
      gradient: gradient.lerp(other.gradient, t),
      shimmer: shimmer.lerp(other.shimmer, t),
      animation: animation.lerp(other.animation, t),
      onPressed: t < 0.5 ? onPressed : other.onPressed,
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
    );
  }

  List<ShadowParams> _lerpShadowList(List<ShadowParams> a, List<ShadowParams> b, double t) {
    return t < 0.5 ? a : b;
  }

  @override
  List<Object?> get props => [
    boxType,
    width,
    height,
    padding,
    margin,
    borderRadius,
    alignment,
    color,
    borderColor,
    borderWidth,
    shadows,
    blur,
    gradient,
    shimmer,
    animation,
    onPressed,
    duration,
    curve,
  ];
}

mixin BoxParamsMixin {
  BoxParams get params;

  Widget buildBox(BuildContext context, Widget content) {
    Widget effectiveContent = params.shimmer.isEnabled
        ? params.shimmer.buildWidget(child: content, context: context)
        : content;

    final decoration = BoxDecoration(
      color: params.color.isVisible ? params.color.resolve(context) : null,
      borderRadius: params.borderRadius,
      border: params.borderWidth > 0
          ? Border.all(color: params.borderColor.resolve(context), width: params.borderWidth)
          : null,
      boxShadow: params.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
      gradient: params.gradient.resolve(context),
    );

    Widget box = AnimatedContainer(
      duration: params.duration,
      curve: params.curve,
      width: params.width,
      height: params.height,
      padding: params.padding,
      margin: params.margin,
      alignment: params.alignment,
      decoration: decoration,
      clipBehavior: params.borderRadius != null ? Clip.antiAlias : Clip.none,
      child: effectiveContent,
    );

    if (params.blur.isEnabled) {
      box = ClipRRect(
        borderRadius: params.borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(filter: params.blur.resolve(), child: box),
      );
    }

    if (params.onPressed != null) {
      box = TapGestureDetector(
        onTap: params.onPressed,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: box),
      );
    }

    return box;
  }
}

class GaplyBoxPreset with GaplyPreset<BoxParams> {
  static final GaplyBoxPreset instance = GaplyBoxPreset._internal();

  GaplyBoxPreset._internal() {
    register('none', const BoxParams());
  }

  static void register(String name, BoxParams params) => instance.add(name, params);

  static BoxParams? of(String name) => instance.get(name);
}
