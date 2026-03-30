// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_color_theme.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyColorThemePreset {
  final Map<Object, GaplyColorTheme> _presets = {};
  final GaplyKeyPolicy _policy = GaplyKeyPolicy.values[0];

  GaplyColorThemePreset._() {
    _initPresets(this);
  }

  static final GaplyColorThemePreset _i = GaplyColorThemePreset._();

  Object _normalize(Object key) {
    if (key is Enum) {
      return _policy == GaplyKeyPolicy.strict
          ? "${key.runtimeType}.${key.name}"
          : key.name;
    }
    if (key is Record) return key.toString();

    final result = key.toString();
    return _policy == GaplyKeyPolicy.insensitive
        ? result.toLowerCase()
        : result;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));
  void add(Object key, GaplyColorTheme style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyColorTheme] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyColorTheme? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyColorThemePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
