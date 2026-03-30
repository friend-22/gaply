// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'package:gaply/src/gaply/styles/color/color_defines.dart';
// import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
//
// import 'gaply_shimmer.dart';
//
// part 'shimmer_preset.g.dart';
//
// @gaplyPreset
// class ShimmerPreset extends GaplyPreset<GaplyShimmer> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   ShimmerPreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _initDefaultPreset() {
//     GaplyShimmerPreset.add(
//       'light',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'dark',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s800),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s700),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'primary',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o20),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o40),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'secondary',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o20),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o40),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'error',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o10),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o20),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'skeleton',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 2000),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'image',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1200),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s300),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'text',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1500),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
//       ),
//     );
//     GaplyShimmerPreset.add(
//       'card',
//       const GaplyShimmer(
//         period: Duration(milliseconds: 1800),
//         baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
//         highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
//       ),
//     );
//   }
// }
