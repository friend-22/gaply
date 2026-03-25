import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'noise_presets.dart';
import 'noise_style_modifier.dart';

part 'noise_widget.dart';

@immutable
class GaplyNoise extends GaplyStyle<GaplyNoise> with _GaplyNoiseMixin, NoiseStyleModifier<GaplyNoise> {
  final double intensity;
  final double density;
  final bool isColored;
  final BlendMode blendMode;

  const GaplyNoise({
    this.intensity = 0.0,
    this.density = 1.0,
    this.isColored = false,
    this.blendMode = BlendMode.srcOver,
  });

  const GaplyNoise.none() : this();

  static void register(String name, GaplyNoise style) => GaplyNoisePreset.register(name, style);

  factory GaplyNoise.preset(String name) {
    final style = GaplyNoisePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown noise filter preset: "$name". '
        'Available presets: ${GaplyNoisePreset.instance.allKeys.join(", ")}',
      );
    }

    return style;
  }

  @override
  GaplyNoise lerp(GaplyNoise? other, double t) {
    if (other == null) return this;
    return GaplyNoise(
      intensity: lerpDouble(intensity, other.intensity, t) ?? intensity,
      density: lerpDouble(density, other.density, t) ?? density,
      isColored: t < 0.5 ? isColored : other.isColored,
      blendMode: t < 0.5 ? blendMode : other.blendMode,
    );
  }

  @override
  GaplyNoise copyWith({double? intensity, double? density, bool? isColored, BlendMode? blendMode}) {
    return GaplyNoise(
      intensity: intensity ?? this.intensity,
      density: density ?? this.density,
      isColored: isColored ?? this.isColored,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  bool get hasEffect => intensity > 0.0;

  @override
  List<Object?> get props => [intensity, density, isColored, blendMode];
}

mixin _GaplyNoiseMixin {
  GaplyNoise get noiseStyle => this as GaplyNoise;

  GaplyNoise copyWithNoise(GaplyNoise noise) {
    return noiseStyle.copyWith();
  }

  Widget buildWidget({required BuildContext context, required Widget child}) {
    if (!noiseStyle.hasEffect) return child;

    return _NoiseWidget(style: noiseStyle, child: child);
  }
}
