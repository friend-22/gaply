// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_translate.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyTranslatePreset {
  final Map<Object, GaplyTranslate> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyTranslatePreset._() {
    _initPresets(this);
  }

  static final GaplyTranslatePreset _i = GaplyTranslatePreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyTranslate style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyTranslatePreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyTranslate? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyTranslatePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
