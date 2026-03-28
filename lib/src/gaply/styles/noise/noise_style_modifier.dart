import 'gaply_noise.dart';

mixin NoiseStyleModifier<T> {
  GaplyNoise get noiseStyle;

  T copyWithNoise(GaplyNoise noise);

  T noiseStyleSet(GaplyNoise noise) => copyWithNoise(noise);

  T noisePreset(Object name) => copyWithNoise(GaplyNoise.preset(name));

  T noiseIntensity(double value) => copyWithNoise(noiseStyle.copyWith(intensity: value));

  T noiseDensity(double value) => copyWithNoise(noiseStyle.copyWith(density: value));

  T noiseColored(bool value) => copyWithNoise(noiseStyle.copyWith(isColored: value));

  T noiseClear() => copyWithNoise(const GaplyNoise.none());
}
