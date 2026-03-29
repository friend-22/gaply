import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'annotations.dart';

class GaplyPresetGenerator extends GeneratorForAnnotation<GaplyPresetGenerate> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final typeParam =
        element.supertype?.typeArguments.first.getDisplayString(withNullability: false) ?? 'dynamic';

    return '''
extension Gaply$className on $className {
  static final $className _instance = $className._internal();
  static $className get i => _instance;
  
  static void add(Object key, $typeParam style) => _instance.presetAdd(key, style);
  
  static $typeParam? of(Object key) => _instance.presetGet(key);
  
  static List<Object> get keys => _instance.presetAllKeys;
  
  static bool has(Object key) => _instance.presetHas(key);
  
  static void addSafe(Object key, $typeParam style) {
    if (_instance.presetHas(key)) {
       GaplyLogger.i("[Gaply$className] Duplicate registration for key: '\$key'. Overwritten.");
    }
    _instance.presetAdd(key, style);
  }
  
  static String error(String category, Object key) => 
      _instance.presetErrorMessage(category, key);
}
''';
  }
}

Builder gaplyBuilder(BuilderOptions options) => SharedPartBuilder([GaplyPresetGenerator()], 'gaply');
