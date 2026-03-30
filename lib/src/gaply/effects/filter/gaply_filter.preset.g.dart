// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_filter.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyFilterPreset {
  final Map<Object, GaplyFilter> _presets = {};
  final GaplyKeyPolicy _policy = GaplyKeyPolicy.values[0];

  GaplyFilterPreset._() {
    _initPresets(this);
  }

  static final GaplyFilterPreset _i = GaplyFilterPreset._();

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
  void add(Object key, GaplyFilter style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i(
          "[GaplyFilter] Duplicate registration for key: '$normalized'. Overwritten.");
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
