// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_shake.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyShakePreset {
  final Map<Object, GaplyShake> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyShakePreset._() {
    _initPresets(this);
  }

  static final GaplyShakePreset _i = GaplyShakePreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyShake style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info(
          "[GaplyShakePreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyShake? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyShakePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
