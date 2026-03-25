import 'dart:ui';

import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'gaply_noise.dart';

class GaplyNoisePreset with GaplyPreset<GaplyNoise> {
  static final GaplyNoisePreset instance = GaplyNoisePreset._internal();
  GaplyNoisePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('paper', const GaplyNoise(intensity: 0.05, density: 0.5));

    add('canvas', const GaplyNoise(intensity: 0.1, density: 1.5));

    add('frosted', const GaplyNoise(intensity: 0.15, density: 2.0, blendMode: BlendMode.overlay));

    add('film', const GaplyNoise(intensity: 0.12, isColored: true, blendMode: BlendMode.softLight));
  }

  static void register(String name, GaplyNoise style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyNoise? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
