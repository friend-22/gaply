// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyBlurPreset on BlurPreset {
  static final BlurPreset _instance = BlurPreset._internal();
  static BlurPreset get i => _instance;

  static void add(Object key, BlurStyle style) =>
      _instance.presetAdd(key, style);

  static BlurStyle? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, BlurStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyBlurPreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
