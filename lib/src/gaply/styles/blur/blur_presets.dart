import 'package:gaply/gaply.dart';

class GaplyBlurPreset with GaplyPreset<BlurStyle> {
  static final GaplyBlurPreset instance = GaplyBlurPreset._internal();

  GaplyBlurPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    const blurLowColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o10);
    const blurMediumColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o20);
    const blurHighColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o30);
    const blurExtraColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o40);

    add('low', const BlurStyle(sigma: 4.0, color: blurLowColor));
    add('medium', const BlurStyle(sigma: 10.0, color: blurMediumColor));
    add('high', const BlurStyle(sigma: 24.0, color: blurHighColor));
    add('extra', const BlurStyle(sigma: 48.0, color: blurExtraColor));

    add('apple', const BlurStyle(sigma: 12.0, color: blurLowColor));
    add('windows', const BlurStyle(sigma: 20.0, color: blurLowColor));
    add('google', const BlurStyle(sigma: 25.0, color: blurLowColor));
  }

  static void register(String name, BlurStyle style) => instance.add(name, style);

  static BlurStyle? of(String name) => instance.get(name);
}
