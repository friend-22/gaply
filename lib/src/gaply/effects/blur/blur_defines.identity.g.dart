// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_defines.dart';

// **************************************************************************
// GaplyIdentityGenerator
// **************************************************************************

abstract class _$GaplyBlurToken extends GaplyIdentity<Object> {
  static final Map<Object, GaplyBlurToken> _registry = {};
  static final GaplyResolvePolicy _policy = GaplyResolvePolicy.values[0];
  static final GaplyBlurToken _none = GaplyBlurToken('none');

  static bool _isInitialized = false;

  const _$GaplyBlurToken(super.value);

  static void _ensureInitialized() {
    if (_isInitialized) return;
    _isInitialized = true;
    GaplyBlurToken._initToken();
  }

  static Object _normalize(Object key) =>
      GaplyResolver.resolve(key, _policy) ?? key;

  static GaplyBlurToken _add(Object key) {
    _ensureInitialized();
    final normalized = _normalize(key);
    return _registry.putIfAbsent(normalized, () => GaplyBlurToken(normalized));
  }

  static GaplyBlurToken _resolve(Object? input) {
    _ensureInitialized();
    if (input is GaplyBlurToken) return input;

    if (input == null) return _none;

    final normalized = _normalize(input);
    return _registry[normalized] ?? _add(normalized);
  }
}
