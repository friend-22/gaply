import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'gaply_layout.dart';

class GaplyLayoutPreset with GaplyPreset<GaplyLayout> {
  static final GaplyLayoutPreset instance = GaplyLayoutPreset._internal();

  GaplyLayoutPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {}

  static void register(String name, GaplyLayout style) => instance.add(name, style);

  static GaplyLayout? of(String name) => instance.get(name);
}
