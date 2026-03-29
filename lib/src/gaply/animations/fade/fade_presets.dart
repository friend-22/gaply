import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'fade_style.dart';

class GaplyFadePreset extends GaplyPreset<FadeStyle> {
  static final GaplyFadePreset _instance = GaplyFadePreset._internal();
  static GaplyFadePreset get i => _instance;

  static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;

  GaplyFadePreset._internal() {
    _initDefaultPresets();
  }

  @override
  GaplyPresetPolicy get presetPolicy => policy;

  static FadeStyle? of(Object key) => _instance.presetGet(key);

  static void has(Object key) => _instance.presetHas(key);

  static void add(Object key, FadeStyle style) => _instance.presetAdd(key, style);

  static void addSafe(Object key, FadeStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i("Duplicate registration for key: '$key'. The existing preset will be overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static List<Object> get keys => _instance.presetAllKeys;

  static String error(String category, Object key) => _instance.presetErrorMessage(category, key);

  void _initDefaultPresets() {}
}
