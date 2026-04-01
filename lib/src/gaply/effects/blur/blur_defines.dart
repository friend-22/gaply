import 'package:gaply/src/inner_gaply_base.dart';

part 'blur_defines.identity.g.dart';

@GaplyIdentityGen(initializer: '_initBlurToken')
class GaplyBlurToken extends _$GaplyBlurToken {
  const GaplyBlurToken(super.value);

  static void _initToken() {}
  static GaplyBlurToken add(Object key) => _$GaplyBlurToken._add(key);
  static GaplyBlurToken resolve(Object input) => _$GaplyBlurToken._resolve(input);
  static GaplyBlurToken get none => _$GaplyBlurToken._none;
}
