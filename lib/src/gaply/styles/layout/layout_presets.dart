import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'gaply_layout.dart';

class GaplyLayoutPreset with GaplyPreset<GaplyLayout> {
  static final GaplyLayoutPreset instance = GaplyLayoutPreset._internal();
  GaplyLayoutPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, GaplyLayout style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyLayout? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
