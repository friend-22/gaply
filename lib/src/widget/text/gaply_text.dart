import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/inner_gaply_base.dart';

import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'text_widget.dart';
import 'gaply_text_modifier.dart';

part 'gaply_text.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyText extends GaplyTweenStyle<GaplyText>
    with
        _GaplyTextMixin,
        GaplyTweenMixin<GaplyText>,
        GaplyColorModifier<GaplyText>,
        GaplyBlurModifier<GaplyText>,
        GaplyShimmerModifier<GaplyText>,
        GaplyMotionModifier<GaplyText>,
        GaplyTextModifier<GaplyText> {
  final double? fontSize;
  final FontWeight? fontWeight;
  final double letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final String? fontFamily;
  final TextAlign alignRole;
  final Set<FontFeature> features;

  final GaplyColor color;
  final GaplyBlur blur;
  final GaplyShimmer shimmer;
  final GaplyMotion motion;

  const GaplyText({
    super.profiler,
    Duration? duration,
    Curve? curve,
    super.onComplete,
    super.progress,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.0,
    this.height,
    this.decoration,
    this.fontFamily,
    this.alignRole = TextAlign.start,
    this.motion = const GaplyMotion.none(),
    this.shimmer = const GaplyShimmer.none(),
    this.color = const GaplyColor.none(),
    this.blur = const GaplyBlur.none(),
    this.features = const {},
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.linear);

  const GaplyText.none() : this();

  static GaplyTextPreset preset = GaplyTextPreset._i;

  factory GaplyText.of(Object key, {GaplyProfiler? profiler}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler);
  }

  @override
  GaplyText lerp(GaplyText? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyText(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        fontSize: lerpDouble(fontSize, other.fontSize, t),
        fontWeight: FontWeight.lerp(fontWeight, other.fontWeight, t),
        color: color.lerp(other.color, t),
        letterSpacing: lerpDouble(letterSpacing, other.letterSpacing, t) ?? other.letterSpacing,
        height: lerpDouble(height, other.height, t),
        decoration: t < 0.5 ? decoration : other.decoration,
        fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
        alignRole: t < 0.5 ? alignRole : other.alignRole,
        blur: blur.lerp(other.blur, t),
        shimmer: shimmer.lerp(other.shimmer, t),
        motion: motion.lerp(other.motion, t),
        features: t < 0.5 ? features : other.features,
      );
    }, tag: 'lerp');
  }

  @override
  GaplyText copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    String? fontFamily,
    TextAlign? alignRole,
    GaplyColor? color,
    GaplyBlur? blur,
    GaplyShimmer? shimmer,
    GaplyMotion? motion,
    Set<FontFeature>? features,
  }) {
    return GaplyText(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      fontFamily: fontFamily ?? this.fontFamily,
      alignRole: alignRole ?? this.alignRole,
      color: color ?? this.color,
      blur: blur ?? this.blur,
      shimmer: shimmer ?? this.shimmer,
      motion: motion ?? this.motion,
      features: features ?? this.features,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fontSize,
    fontWeight,
    letterSpacing,
    height,
    decoration,
    fontFamily,
    alignRole,
    color,
    blur,
    shimmer,
    motion,
    features,
  ];

  @override
  bool get hasEffect => true;
}

mixin _GaplyTextMixin {
  GaplyText get _self => this as GaplyText;
  GaplyText get gaplyText => _self;

  GaplyText copyWithText(GaplyText text) {
    return _self.copyWith(
      profiler: text.profiler,
      duration: text.duration,
      curve: text.curve,
      onComplete: text.onComplete,
      progress: text.progress,
      fontSize: text.fontSize,
      fontWeight: text.fontWeight,
      color: text.color,
      letterSpacing: text.letterSpacing,
      height: text.height,
      decoration: text.decoration,
      fontFamily: text.fontFamily,
      alignRole: text.alignRole,
      blur: text.blur,
      shimmer: text.shimmer,
      motion: text.motion,
      features: text.features,
    );
  }

  TextStyle resolve(BuildContext context) {
    return TextStyle(
      fontSize: _self.fontSize,
      fontWeight: _self.fontWeight,
      color: _self.color.resolve(context),
      letterSpacing: _self.letterSpacing,
      height: _self.height,
      decoration: _self.decoration,
      fontFamily: _self.fontFamily,
      fontFeatures: _self.features.toList(),
    );
  }

  Widget buildWidget({required String text}) {
    return GaplyTextWidget(text, gaplyText: _self);
  }
}

void _initPresets(GaplyTextPreset preset) {}
