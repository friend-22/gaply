import 'package:gaply/src/core/base/params_base.dart';

mixin GaplyPreset<T extends ParamsBase> {
  final Map<String, T> _presets = {};

  void add(String name, T params) => _presets[name] = params;

  T? get(String name) => _presets[name];

  bool get hasPreset => _presets.isNotEmpty;

  List<String> get allKeys => _presets.keys.toList();
}
