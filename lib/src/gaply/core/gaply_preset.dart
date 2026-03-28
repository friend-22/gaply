import 'gaply_style.dart';

mixin GaplyPreset<T extends GaplyStyle> {
  final Map<Object, T> _presets = {};

  Object _resolveKey(Object name) {
    if (name is String) return name;
    if (name is Enum) return "${name.runtimeType}.${name.name}";
    throw ArgumentError("GaplyPreset key must be String or Enum. Received: ${name.runtimeType}");
  }

  void add(Object name, T style) => _presets[_resolveKey(name)] = style;

  T? get(Object name) => _presets[_resolveKey(name)];

  List<Object> get allKeys => _presets.keys.toList();

  @override
  String toString() => allKeys.join(", ");

  String errorMessage(String category, Object name) {
    final available = _presets.keys;
    return "Unknown $category preset: '$name'. "
        "Available presets: ${available.isEmpty ? "None" : available.join(", ")}";
  }
}
