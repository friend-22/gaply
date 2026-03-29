// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reveal_preset.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

extension GaplyRevealPreset on RevealPreset {
  static final RevealPreset _instance = RevealPreset._internal();
  static RevealPreset get i => _instance;

  static void add(Object key, RevealStyle style) =>
      _instance.presetAdd(key, style);

  static RevealStyle? of(Object key) => _instance.presetGet(key);

  static List<Object> get keys => _instance.presetAllKeys;

  static bool has(Object key) => _instance.presetHas(key);

  static void addSafe(Object key, RevealStyle style) {
    if (_instance.presetHas(key)) {
      GaplyLogger.i(
          "[GaplyRevealPreset] Duplicate registration for key: '$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }

  static String error(String category, Object key) =>
      _instance.presetErrorMessage(category, key);
}
