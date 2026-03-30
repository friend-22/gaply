import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'gaply_noise_modifier.dart';

part 'noise_widget.dart';
part 'gaply_noise.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyNoise extends GaplyStyle<GaplyNoise> with _GaplyNoiseMixin, GaplyNoiseModifier<GaplyNoise> {
  final double intensity;
  final double density;
  final bool isColored;
  final BlendMode blendMode;

  const GaplyNoise({
    super.profiler,
    this.intensity = 0.0,
    this.density = 1.0,
    this.isColored = false,
    this.blendMode = BlendMode.srcOver,
  });

  const GaplyNoise.none() : this();

  // static void add(Object key, GaplyNoise style) => GaplyNoisePreset.add(key, style);
  //
  // factory GaplyNoise.preset(Object key, {GaplyProfiler? profiler}) {
  //   final style = GaplyNoisePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyNoisePreset.error("GaplyNoise", key));
  //   }
  //   return style.copyWith(profiler: profiler);
  // }

  @override
  GaplyNoise copyWith({
    GaplyProfiler? profiler,
    double? intensity,
    double? density,
    bool? isColored,
    BlendMode? blendMode,
  }) {
    return GaplyNoise(
      profiler: profiler ?? this.profiler,
      intensity: intensity ?? this.intensity,
      density: density ?? this.density,
      isColored: isColored ?? this.isColored,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  GaplyNoise lerp(GaplyNoise? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyNoise(
        profiler: other.profiler,
        intensity: lerpDouble(intensity, other.intensity, t) ?? intensity,
        density: lerpDouble(density, other.density, t) ?? density,
        isColored: t < 0.5 ? isColored : other.isColored,
        blendMode: t < 0.5 ? blendMode : other.blendMode,
      );
    }, tag: 'lerp');
  }

  @override
  bool get hasEffect => intensity > 0.0;

  @override
  List<Object?> get props => [intensity, density, isColored, blendMode];
}

mixin _GaplyNoiseMixin {
  GaplyNoise get _self => this as GaplyNoise;
  GaplyNoise get gaplyNoise => _self;

  GaplyNoise copyWithNoise(GaplyNoise noise) {
    return _self.copyWith(
      profiler: noise.profiler,
      intensity: noise.intensity,
      density: noise.density,
      isColored: noise.isColored,
      blendMode: noise.blendMode,
    );
  }

  Widget buildWidget({required BuildContext context, required Widget child}) {
    if (!_self.hasEffect) return child;

    return _NoiseWidget(style: _self, child: child);
  }
}

void _initPresets(GaplyNoisePreset preset) {
  preset.add('paper', const GaplyNoise(intensity: 0.05, density: 0.5));

  preset.add('canvas', const GaplyNoise(intensity: 0.1, density: 1.5));

  preset.add('frosted', const GaplyNoise(intensity: 0.15, density: 2.0, blendMode: BlendMode.overlay));

  preset.add('film', const GaplyNoise(intensity: 0.12, isColored: true, blendMode: BlendMode.softLight));
}
