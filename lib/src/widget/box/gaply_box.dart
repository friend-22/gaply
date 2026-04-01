import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/inner_gaply_base.dart';

import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_widget.dart';
import 'gaply_box_modifier.dart';

part 'gaply_box.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyBox extends GaplyTweenStyle<GaplyBox>
    with
        _GaplyBoxMixin,
        GaplyTweenMixin<GaplyBox>,
        GaplyColorModifier<GaplyBox>,
        GaplyBorderColorModifier<GaplyBox>,
        GaplyLayoutModifier<GaplyBox>,
        GaplyBlurModifier<GaplyBox>,
        GaplyGradientModifier<GaplyBox>,
        GaplyShimmerModifier<GaplyBox>,
        GaplyFilterModifier<GaplyBox>,
        GaplyNoiseModifier<GaplyBox>,
        GaplyManyShadowModifier<GaplyBox>,
        GaplyMotionModifier<GaplyBox>,
        GaplyBoxModifier<GaplyBox> {
  // 1. Layout & Shape
  final GaplyLayout layout;

  // 2. Static Style
  final GaplyColor color;
  final GaplyColor borderColor;
  final List<GaplyShadow> shadows;
  final GaplyBlur blur;
  final GaplyGradient gradient;

  // 3. Dynamic Effects
  final GaplyShimmer shimmer;
  final GaplyFilter filter;
  final GaplyNoise noise;
  final GaplyMotion motion;

  // 4. button Style
  final VoidCallback? onPressed;

  const GaplyBox({
    super.profiler,
    Duration? duration,
    Curve? curve,
    super.onComplete,
    super.progress,
    this.layout = const GaplyLayout.none(),
    this.color = const GaplyColor.none(),
    this.borderColor = const GaplyColor.none(),
    this.shadows = const [],
    this.blur = const GaplyBlur.none(),
    this.gradient = const GaplyGradient.none(),
    this.shimmer = const GaplyShimmer.none(),
    this.filter = const GaplyFilter.none(),
    this.noise = const GaplyNoise.none(),
    this.motion = const GaplyMotion.none(),
    this.onPressed,
  }) : super(duration: duration ?? const Duration(milliseconds: 300), curve: curve ?? Curves.linear);

  const GaplyBox.none() : this();

  static GaplyBoxPreset preset = GaplyBoxPreset._i;

  factory GaplyBox.of(Object key, {GaplyProfiler? profiler}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler);
  }

  @override
  GaplyBox copyWith({
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
    GaplyBlur? blur,
    GaplyGradient? gradient,
    GaplyShimmer? shimmer,
    GaplyFilter? filter,
    GaplyNoise? noise,
    GaplyMotion? motion,
    VoidCallback? onPressed,
  }) {
    return GaplyBox(
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
  GaplyBox lerp(GaplyBox? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyBox(
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

mixin _GaplyBoxMixin {
  GaplyBox get _self => this as GaplyBox;
  GaplyBox get gaplyBox => _self;

  GaplyBox copyWithBox(GaplyBox box) {
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
    return GaplyBoxWidget(gaplyBox: _self, child: child);
  }
}

void _initPresets(GaplyBoxPreset preset) {
  preset.add('rainbow', GaplyBox(gradient: GaplyGradient.of('rainbow')));

  preset.add(
    'card',
    const GaplyBox(
      layout: GaplyLayout(padding: EdgeInsets.all(16), borderRadius: BorderRadius.all(Radius.circular(12))),
      color: GaplyColor(token: GaplyColorToken.surface),
    ),
  );

  preset.add(
    'button',
    const GaplyBox(
      layout: GaplyLayout(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      color: GaplyColor(token: GaplyColorToken.primary),
      duration: Duration(milliseconds: 200),
    ),
  );
}
