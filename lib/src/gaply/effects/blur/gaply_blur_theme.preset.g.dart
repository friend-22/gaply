// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaply_blur_theme.dart';

// **************************************************************************
// GaplyPresetGenerator
// **************************************************************************

class GaplyBlurThemePreset {
  final Map<Object, GaplyBlurTheme> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];

  GaplyBlurThemePreset._() {
    _initPresets(this);
  }

  static final GaplyBlurThemePreset _i = GaplyBlurThemePreset._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));

  void add(Object key, GaplyBlurTheme style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info(
          "[GaplyBlurThemePreset] Duplicate registration for key: '$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }

  GaplyBlurTheme? get(Object key) => _presets[_normalize(key)];

  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown GaplyBlurThemePreset: '$normalized'. "
        "Available: ${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
