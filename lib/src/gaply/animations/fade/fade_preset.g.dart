// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fade_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyFadePreset on FadePreset {
  static final FadePreset _instance = FadePreset._internal();
  static FadePreset get i => _instance;

  static void add(Object key, FadeStyle style) =>
      _instance.presetAdd(key, style);

  static FadeStyle? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, FadeStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyFadePreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
