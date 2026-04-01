// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'annotations.dart';

class GaplyPresetGenerator extends GeneratorForAnnotation<GaplyPresetGen> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final presetClassName = '${className}Preset';

    final initializerName = annotation.read('initializer').isNull
        ? null
        : annotation.read('initializer').stringValue;

    final policyIndex = annotation.read('policy').objectValue.getField('index')?.toIntValue() ?? 0;

    return '''
class $presetClassName {
  final Map<Object, $className> _presets = {};
  final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[$policyIndex];
  
  $presetClassName._() {
    ${initializerName != null ? '$initializerName(this);' : ''}
  }
  
  static final $presetClassName _i = $presetClassName._();

  Object _normalize(Object key) {
    return GaplyResolver.resolve(key, _policy) ?? key;
  }

  bool has(Object key) => _presets.containsKey(_normalize(key));
  
  void add(Object key, $className style, {bool overwrite = false}) {
    final normalized = _normalize(key);
    if (_presets.containsKey(normalized) && !overwrite) {
      GaplyHub.info("[$presetClassName] Duplicate registration for key: '\$normalized'. Overwritten.");
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

class GaplyIdentityGenerator extends GeneratorForAnnotation<GaplyIdentityGen> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) return '';

    final className = element.name;
    final genClassName = '_\$$className';

    final initializerName = annotation.read('initializer').isNull
        ? null
        : annotation.read('initializer').stringValue;

    final policyIndex = annotation.read('policy').objectValue.getField('index')?.toIntValue() ?? 0;

    return '''
abstract class $genClassName extends GaplyIdentity<Object> {
  static final Map<Object, $className> _registry = {};
  static final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[$policyIndex];
  static final GaplyBlurToken _none = GaplyBlurToken('none');
  
  static bool _isInitialized = false;

  const $genClassName(super.value);

  static void _ensureInitialized() {
    if (_isInitialized) return;
    _isInitialized = true;
    $className._initToken();
  }

  static Object _normalize(Object key) => GaplyResolver.resolve(key, _policy) ?? key;

  static $className _add(Object key) {
    _ensureInitialized();
    final normalized = _normalize(key);
    return _registry.putIfAbsent(normalized, () => $className(normalized));
  }

  static $className _resolve(Object? input) {
    _ensureInitialized();
    if (input is $className) return input;
    
    if (input == null) return _none;
    
    final normalized = _normalize(input);
    return _registry[normalized] ?? _add(normalized);
  }
}
''';
  }

  dynamic _getLiteral(DartObject obj) {
    if (obj.isNull) return null;
    return obj.toBoolValue() ?? obj.toDoubleValue() ?? obj.toIntValue() ?? obj.toStringValue();
  }
}

Builder gaplyIdentityBuilder(BuilderOptions options) =>
    PartBuilder([GaplyIdentityGenerator()], '.identity.g.dart');
