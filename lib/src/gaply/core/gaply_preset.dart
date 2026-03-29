import 'gaply_style.dart';

enum GaplyPresetPolicy { flexible, strict, insensitive }

abstract class GaplyPreset<T extends GaplyStyle> {
  final Map<Object, T> _presets = {};

  GaplyPresetPolicy get presetPolicy;

  Object _normalize(Object key) {
    String result;

    if (key is Enum) {
      result = switch (presetPolicy) {
        GaplyPresetPolicy.strict => "${key.runtimeType}.${key.name}",
        _ => key.name,
      };
    } else if (key is Record) {
      result = key.toString();
    } else {
      result = key.toString();
    }

    return presetPolicy == GaplyPresetPolicy.insensitive ? result.toLowerCase() : result;
  }

  bool presetHas(Object key) => _presets.containsKey(_normalize(key));
  void presetAdd(Object key, T style) => _presets[_normalize(key)] = style;
  T? presetGet(Object key) => _presets[_normalize(key)];
  List<Object> get presetAllKeys => _presets.keys.toList();

  @override
  String toString() => "Presets[${presetPolicy.name}]: ${presetAllKeys.join(', ')}";

  String presetErrorMessage(String category, Object key) {
    final normalizedKey = _normalize(key);
    return "Unknown $category: '$normalizedKey'. "
        "Available: ${presetAllKeys.isEmpty ? 'None' : presetAllKeys.join(', ')}";
  }
}
