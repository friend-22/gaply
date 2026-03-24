import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';

import 'gaply_shimmer.dart';

class GaplyShimmerPreset with GaplyPreset<GaplyShimmer> {
  static final GaplyShimmerPreset instance = GaplyShimmerPreset._internal();
  GaplyShimmerPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'light',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
    add(
      'dark',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s800),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s700),
      ),
    );
    add(
      'primary',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.primary, opacity: ColorOpacity.o20),
        highlightColor: GaplyColor.fromRole(ColorRole.primary, opacity: ColorOpacity.o40),
      ),
    );
    add(
      'secondary',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.secondary, opacity: ColorOpacity.o20),
        highlightColor: GaplyColor.fromRole(ColorRole.secondary, opacity: ColorOpacity.o40),
      ),
    );
    add(
      'error',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.error, opacity: ColorOpacity.o10),
        highlightColor: GaplyColor.fromRole(ColorRole.error, opacity: ColorOpacity.o20),
      ),
    );
    add(
      'skeleton',
      const GaplyShimmer(
        period: Duration(milliseconds: 2000),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'image',
      const GaplyShimmer(
        period: Duration(milliseconds: 1200),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s300),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'text',
      const GaplyShimmer(
        period: Duration(milliseconds: 1500),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'card',
      const GaplyShimmer(
        period: Duration(milliseconds: 1800),
        baseColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s100),
        highlightColor: GaplyColor.fromRole(ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
  }

  static void register(String name, GaplyShimmer style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyShimmer? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
