// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_rotate.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyRotatePreset {
  final Map<Object, GaplyRotate> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyRotatePreset._() {
    _initPresets(this);
  }

  static final GaplyRotatePreset _i = GaplyRotatePreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyRotate style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyRotatePreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyRotate? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyRotatePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
