// import 'dart:ui';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'gaply_noise.dart';
//
// part 'noise_preset.g.dart';
//
// @gaplyPreset
// class NoisePreset extends GaplyPreset<GaplyNoise> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   NoisePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyNoisePreset.add('paper', const GaplyNoise(intensity: 0.05, density: 0.5));
//
//     GaplyNoisePreset.add('canvas', const GaplyNoise(intensity: 0.1, density: 1.5));
//
//     GaplyNoisePreset.add(
//       'frosted',
//       const GaplyNoise(intensity: 0.15, density: 2.0, blendMode: BlendMode.overlay),
//     );
//
//     GaplyNoisePreset.add(
//       'film',
//       const GaplyNoise(intensity: 0.12, isColored: true, blendMode: BlendMode.softLight),
//     );
//   }
// }
