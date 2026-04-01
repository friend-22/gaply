// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_shimmer.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyShimmerPreset {
  final Map<Object, GaplyShimmer> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyShimmerPreset._() {
    _initPresets(this);
  }

  static final GaplyShimmerPreset _i = GaplyShimmerPreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyShimmer style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info(
          "[GaplyShimmerPreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyShimmer? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyShimmerPreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
