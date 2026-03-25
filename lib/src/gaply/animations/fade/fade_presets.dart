import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'fade_style.dart';

class GaplyFadePreset with GaplyPreset<FadeStyle> {
  static final GaplyFadePreset instance = GaplyFadePreset._internal();

  GaplyFadePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, FadeStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static FadeStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
