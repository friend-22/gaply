// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyMotionPreset on MotionPreset {
  static final MotionPreset _instance = MotionPreset._internal();
  static MotionPreset get i => _instance;

  static void add(Object key, GaplyMotion style) =>
      _instance.presetAdd(key, style);

  static GaplyMotion? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, GaplyMotion style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyMotionPreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
