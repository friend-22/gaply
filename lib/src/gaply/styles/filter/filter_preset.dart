// import 'dart:ui';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
//
// import 'gaply_filter.dart';
//
// part 'filter_preset.g.dart';
//
// @gaplyPreset
// class FilterPreset extends GaplyPreset<GaplyFilter> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   FilterPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyFilterPreset.add('grayscale', const GaplyFilter(grayscale: 1.0));
//
//     GaplyFilterPreset.add('vivid', const GaplyFilter(contrast: 1.4, brightness: 0.1));
//
//     GaplyFilterPreset.add('dim', const GaplyFilter(brightness: -0.3));
//
//     GaplyFilterPreset.add(
//       'warm',
//       const GaplyFilter(blendColor: GaplyColor.fromColor(Color(0x33FFA500)), blendMode: BlendMode.colorBurn),
//     );
//
//     GaplyFilterPreset.add(
//       'cool',
//       const GaplyFilter(blendColor: GaplyColor.fromColor(Color(0x330000FF)), blendMode: BlendMode.softLight),
//     );
//   }
// }
