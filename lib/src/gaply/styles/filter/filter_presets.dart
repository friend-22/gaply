import 'dart:ui';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';

import 'gaply_filter.dart';

class GaplyFilterPreset with GaplyPreset<GaplyFilter> {
  static final GaplyFilterPreset instance = GaplyFilterPreset._internal();
  GaplyFilterPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('grayscale', const GaplyFilter(grayscale: 1.0));

    add('vivid', const GaplyFilter(contrast: 1.4, brightness: 0.1));

    add('dim', const GaplyFilter(brightness: -0.3));

    add(
      'warm',
      const GaplyFilter(blendColor: GaplyColor.fromColor(Color(0x33FFA500)), blendMode: BlendMode.colorBurn),
    );

    add(
      'cool',
      const GaplyFilter(blendColor: GaplyColor.fromColor(Color(0x330000FF)), blendMode: BlendMode.softLight),
    );
  }

  static void register(String name, GaplyFilter style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyFilter? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
