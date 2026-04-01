// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_blur.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyBlurPreset {
  final Map<Object, GaplyBlur> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyBlurPreset._() {
    _initPresets(this);
  }

  static final GaplyBlurPreset _i = GaplyBlurPreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyBlur style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info(
          "[GaplyBlurPreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyBlur? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyBlurPreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
