import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'gaply_noise.dart';

mixin GaplyNoiseModifier<T> {
  GaplyNoise get gaplyNoise;

  T copyWithNoise(GaplyNoise noise);

  T noiseStyle(GaplyNoise noise) => copyWithNoise(noise);

  T noiseOf(Object key, {GaplyProfiler? profiler}) => copyWithNoise(GaplyNoise.of(key, profiler: profiler));

  T noiseIntensity(double value) => copyWithNoise(gaplyNoise.copyWith(intensity: value));

  T noiseDensity(double value) => copyWithNoise(gaplyNoise.copyWith(density: value));

  T noiseColored(bool value) => copyWithNoise(gaplyNoise.copyWith(isColored: value));

  T noiseClear() => copyWithNoise(const GaplyNoise.none());
}
