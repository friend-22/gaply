import 'gaply_style.dart';

mixin GaplyPreset<T extends GaplyStyle> {
  final Map<String, T> _presets = {};

  void add(String name, T style) => _presets[name] = style;

  T? get(String name) => _presets[name];

  bool get hasPreset => _presets.isNotEmpty;

  List<String> get allKeys => _presets.keys.toList();
}
