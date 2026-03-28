import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'text_style.dart';

class GaplyTextPreset with GaplyPreset<GaplyTextStyle> {
  static final GaplyTextPreset instance = GaplyTextPreset._internal();

  GaplyTextPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {}

  static void register(Object name, GaplyTextStyle style) => instance.add(name, style);

  static GaplyTextStyle? of(Object name) => instance.get(name);
}
