import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'flip_style.dart';

class GaplyFlipPreset with GaplyPreset<FlipStyle> {
  static final GaplyFlipPreset instance = GaplyFlipPreset._internal();
  GaplyFlipPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, FlipStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static FlipStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
