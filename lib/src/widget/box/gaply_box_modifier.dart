import 'package:flutter/material.dart';

import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'gaply_box.dart';

mixin GaplyBoxModifier<T>
    on
        GaplyColorModifier<T>,
        GaplyBorderColorModifier<T>,
        GaplyLayoutModifier<T>,
        GaplyBlurModifier<T>,
        GaplyGradientModifier<T>,
        GaplyShimmerModifier<T>,
        GaplyFilterModifier<T>,
        GaplyNoiseModifier<T>,
        GaplyManyShadowModifier<T>,
        GaplyMotionModifier<T> {
  GaplyBox get gaplyBox;
  T copyWithBox(GaplyBox box);

  T boxStyle(GaplyBox box) => copyWithBox(box);

  T boxOf(Object key, {GaplyProfiler? profiler}) => copyWithBox(GaplyBox.of(key, profiler: profiler));

  //Layout Style
  @override
  GaplyLayout get gaplyLayout => gaplyBox.layout;
  @override
  T copyWithLayout(GaplyLayout layout) => copyWithBox(gaplyBox.copyWith(layout: layout));

  //Blur Style
  @override
  GaplyBlur get gaplyBlur => gaplyBox.blur;
  @override
  T copyWithBlur(GaplyBlur blur) => copyWithBox(gaplyBox.copyWith(blur: blur));

  //Gradient Style
  @override
  GaplyGradient get gaplyGradient => gaplyBox.gradient;
  @override
  T copyWithGradient(GaplyGradient gradient) => copyWithBox(gaplyBox.copyWith(gradient: gradient));

  //Shimmer Style
  @override
  GaplyShimmer get gaplyShimmer => gaplyBox.shimmer;
  @override
  T copyWithShimmer(GaplyShimmer shimmer) => copyWithBox(gaplyBox.copyWith(shimmer: shimmer));

  //Shadow Style
  @override
  List<GaplyShadow> get gaplyShadow => gaplyBox.shadows;
  @override
  T copyWithShadow(List<GaplyShadow> shadows) => copyWithBox(gaplyBox.copyWith(shadows: shadows));

  //Filter Style
  @override
  GaplyFilter get gaplyFilter => gaplyBox.filter;
  @override
  T copyWithFilter(GaplyFilter filter) => copyWithBox(gaplyBox.copyWith(filter: filter));

  //Noise Style
  @override
  GaplyNoise get gaplyNoise => gaplyBox.noise;
  @override
  T copyWithNoise(GaplyNoise noise) => copyWithBox(gaplyBox.copyWith(noise: noise));

  //Motion Style
  @override
  GaplyMotion get gaplyMotion => gaplyBox.motion;
  @override
  T copyWithMotion(GaplyMotion motion) => copyWithBox(gaplyBox.copyWith(motion: motion));

  //Color Style
  @override
  GaplyColor get gaplyColor => gaplyBox.color;
  @override
  T copyWithColor(GaplyColor color) => copyWithBox(gaplyBox.copyWith(color: color));

  //BorderColor Style
  @override
  GaplyColor get gaplyBorderColor => gaplyBox.borderColor;
  @override
  T copyWithBorderColor(GaplyColor color) => copyWithBox(gaplyBox.copyWith(borderColor: color));

  T boxGlassToken(GaplyColorToken token, {double? shade, double? borderShade, double borderWidth = 1.0}) {
    final resolvedShade = shade != null ? GaplyColorShade.resolve(shade) : GaplyColorShade.s50;
    final resolvedBorderShade = borderShade != null
        ? GaplyColorShade.resolve(borderShade)
        : GaplyColorShade.s100;

    return copyWithBox(
      gaplyBox.copyWith(
        color: gaplyBox.color.copyWith(token: token, shade: resolvedShade),
        borderColor: gaplyBox.borderColor.copyWith(token: token, shade: resolvedBorderShade),
        layout: gaplyBox.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxGlass(Color? value, {double? shade, double? borderShade, double borderWidth = 1.0}) {
    final resolvedShade = shade != null ? GaplyColorShade.resolve(shade) : GaplyColorShade.s50;
    final resolvedBorderShade = borderShade != null
        ? GaplyColorShade.resolve(borderShade)
        : GaplyColorShade.s100;

    return copyWithBox(
      gaplyBox.copyWith(
        color: gaplyBox.color.copyWith(customColor: value, shade: resolvedShade),
        borderColor: gaplyBox.borderColor.copyWith(customColor: value, shade: resolvedBorderShade),
        layout: gaplyBox.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxOnPressed(VoidCallback? action) => copyWithBox(gaplyBox.copyWith(onPressed: action));
  T boxDuration(Duration value) => copyWithBox(gaplyBox.copyWith(duration: value));
  T boxCurve(Curve value) => copyWithBox(gaplyBox.copyWith(curve: value));
}
