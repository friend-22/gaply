// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_skew.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplySkewPreset {
  final Map<Object, GaplySkew> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplySkewPreset._() {
    _initPresets(this);
  }

  static final GaplySkewPreset _i = GaplySkewPreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplySkew style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplySkewPreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplySkew? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplySkewPreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
