// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flip_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyFlipPreset on FlipPreset {
  static final FlipPreset _instance = FlipPreset._internal();
  static FlipPreset get i => _instance;

  static void add(Object key, FlipStyle style) =>
      _instance.presetAdd(key, style);

  static FlipStyle? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, FlipStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyFlipPreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
