import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'flip_style.dart';

class GaplyFlipPreset with GaplyPreset<FlipStyle> {
  static final GaplyFlipPreset instance = GaplyFlipPreset._internal();
  GaplyFlipPreset._internal() {
    _initDefaultPresets();
  }
  void _initDefaultPresets() {}

  static void register(String name, FlipStyle style) => instance.add(name, style);

  static FlipStyle? of(String name) => instance.get(name);
}
