// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'annotations.dart';

class GaplyPresetGenerator extends GeneratorForAnnotation<GaplyPresetGen> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final presetClassName = className.endsWith('Style')
        ? className.replaceFirst('Style', 'Preset')
        : '${className}Preset';

    final initializerName = annotation.read('initializer').isNull
        ? null
        : annotation.read('initializer').stringValue;

    final policyIndex = annotation.read('policy').objectValue.getField('index')?.toIntValue() ?? 0;

    return '''
class $presetClassName {
  final Map<Object, $className> _presets = {};
  final GaplyKeyPolicy _policy = GaplyKeyPolicy.values[$policyIndex];
  
  $presetClassName._() {
    ${initializerName != null ? '$initializerName(this);' : ''}
  }
  
  static final $presetClassName _i = $presetClassName._();

  Object _normalize(Object key) {
    if (key is Enum) {
      return _policy == GaplyKeyPolicy.strict 
          ? "\${key.runtimeType}.\${key.name}" 
          : key.name;
    }
    if (key is Record) return key.toString();
    
    final result = key.toString();
    return _policy == GaplyKeyPolicy.insensitive ? result.toLowerCase() : result;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));
  void add(Object key, $className style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyLogger.i("[$className] Duplicate registration for key: '\$normalized'. Overwritten.");
    }
    _presets[_normalize(key)] = style;
  }
  
  $className? get(Object key) => _presets[_normalize(key)];
  
  List<Object> get keys => _presets.keys.toList();

  String error(Object key) {
    final normalized = _normalize(key);
    return "Unknown $presetClassName: '\$normalized'. "
      "Available: \${_presets.keys.isEmpty ? 'None' : _presets.keys.join(', ')}";
  }
}
''';
  }
}

Builder gaplyPresetBuilder(BuilderOptions options) => PartBuilder([GaplyPresetGenerator()], '.preset.g.dart');
