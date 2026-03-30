import 'package:gaply/src/utils/gaply_profiler.dart';
import 'gaply_noise.dart';

mixin GaplyNoiseModifier<T> {
  GaplyNoise get gaplyNoise;

  T copyWithNoise(GaplyNoise noise);

  T noiseStyleSet(GaplyNoise noise) => copyWithNoise(noise);

  // T noisePreset(Object name) => copyWithNoise(GaplyNoise.preset(name));

  T noiseIntensity(double value) => copyWithNoise(gaplyNoise.copyWith(intensity: value));

  T noiseDensity(double value) => copyWithNoise(gaplyNoise.copyWith(density: value));

  T noiseColored(bool value) => copyWithNoise(gaplyNoise.copyWith(isColored: value));

  T noiseClear() => copyWithNoise(const GaplyNoise.none());
}
