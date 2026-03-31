// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_motion.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyMotionPreset {
  final Map<Object, GaplyMotion> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyMotionPreset._() {
    _initPresets(this);
  }

  static final GaplyMotionPreset _i = GaplyMotionPreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyMotion style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyMotionPreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyMotion? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyMotionPreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
