// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotate_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyRotatePreset on RotatePreset {
  static final RotatePreset _instance = RotatePreset._internal();
  static RotatePreset get i => _instance;

  static void add(Object key, RotateStyle style) =>
      _instance.presetAdd(key, style);

  static RotateStyle? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, RotateStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyRotatePreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
