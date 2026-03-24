import 'package:gaply/gaply.dart';

class GaplyBlurPreset with GaplyPreset<BlurStyle> {
  static final GaplyBlurPreset instance = GaplyBlurPreset._internal();

  GaplyBlurPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    const blurLowColor = GaplyColor.shadow(opacity: ColorOpacity.o10);
    const blurMediumColor = GaplyColor.shadow(opacity: ColorOpacity.o20);
    const blurHighColor = GaplyColor.shadow(opacity: ColorOpacity.o30);
    const blurExtraColor = GaplyColor.shadow(opacity: ColorOpacity.o40);

    add('low', const BlurStyle(sigma: 4.0, color: blurLowColor));
    add('medium', const BlurStyle(sigma: 10.0, color: blurMediumColor));
    add('high', const BlurStyle(sigma: 24.0, color: blurHighColor));
    add('extra', const BlurStyle(sigma: 48.0, color: blurExtraColor));

    add('apple', const BlurStyle(sigma: 12.0, color: blurLowColor));
    add('windows', const BlurStyle(sigma: 20.0, color: blurLowColor));
    add('google', const BlurStyle(sigma: 25.0, color: blurLowColor));
  }

  static void register(String name, BlurStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static BlurStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
