import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'rotate_style.dart';

class GaplyRotatePreset with GaplyPreset<RotateStyle> {
  static final GaplyRotatePreset instance = GaplyRotatePreset._internal();
  GaplyRotatePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, RotateStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static RotateStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
