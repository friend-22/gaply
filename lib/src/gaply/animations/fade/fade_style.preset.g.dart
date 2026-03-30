// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fade_style.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyFadePreset {
  final Map<Object, GaplyFadeStyle> _presets = {};
  final GaplyKeyPolicy _policy = GaplyKeyPolicy.values[0];

  GaplyFadePreset._() {
    _initPresets(this);
  }

  static final GaplyFadePreset _i = GaplyFadePreset._();

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
  void add(Object key, GaplyFadeStyle style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyFadeStyle] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyFadeStyle? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyFadePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
