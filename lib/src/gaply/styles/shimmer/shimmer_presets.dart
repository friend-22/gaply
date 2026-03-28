import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/color_defines.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';

import 'gaply_shimmer.dart';

class GaplyShimmerPreset with GaplyPreset<GaplyShimmer> {
  static final GaplyShimmerPreset instance = GaplyShimmerPreset._internal();

  GaplyShimmerPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'light',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
      ),
    );
    add(
      'dark',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s800),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s700),
      ),
    );
    add(
      'primary',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o20),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o40),
      ),
    );
    add(
      'secondary',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o20),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o40),
      ),
    );
    add(
      'error',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o10),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o20),
      ),
    );
    add(
      'skeleton',
      const GaplyShimmer(
        period: Duration(milliseconds: 2000),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
      ),
    );
    add(
      'image',
      const GaplyShimmer(
        period: Duration(milliseconds: 1200),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s300),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
      ),
    );
    add(
      'text',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
      ),
    );
    add(
      'card',
      const GaplyShimmer(
        period: Duration(milliseconds: 1800),
        baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
        highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
      ),
    );
  }

  static void register(Object name, GaplyShimmer style) => instance.add(name, style);

  static GaplyShimmer? of(Object name) => instance.get(name);
}
