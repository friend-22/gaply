// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_filter.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyFilterPreset {
  final Map<Object, GaplyFilter> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyFilterPreset._() {
    _initPresets(this);
  }

  static final GaplyFilterPreset _i = GaplyFilterPreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyFilter style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info(
          "[GaplyFilterPreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyFilter? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyFilterPreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
