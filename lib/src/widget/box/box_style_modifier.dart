import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/styles/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_style.dart';

mixin BoxStyleModifier<T>
    on
        ColorStyleModifier<T>,
        BorderColorStyleModifier<T>,
        LayoutStyleModifier<T>,
        BlurStyleModifier<T>,
        GradientStyleModifier<T>,
        ShimmerStyleModifier<T>,
        FilterStyleModifier<T>,
        NoiseStyleModifier<T>,
        ManyShadowStyleModifier<T>,
        GaplyMotionModifier<T> {
  BoxStyle get boxStyle;
  T copyWithBox(BoxStyle box);

  //Layout Style
  @override
  GaplyLayout get layoutStyle => boxStyle.layout;
  @override
  T copyWithLayout(GaplyLayout layout) => copyWithBox(boxStyle.copyWith(layout: layout));

  //Blur Style
  @override
  GaplyBlur get blurStyle => boxStyle.blur;
  @override
  T copyWithBlur(GaplyBlur blur) => copyWithBox(boxStyle.copyWith(blur: blur));

  //Gradient Style
  @override
  GaplyGradient get gradientStyle => boxStyle.gradient;
  @override
  T copyWithGradient(GaplyGradient gradient) => copyWithBox(boxStyle.copyWith(gradient: gradient));

  //Shimmer Style
  @override
  GaplyShimmer get shimmerStyle => boxStyle.shimmer;
  @override
  T copyWithShimmer(GaplyShimmer shimmer) => copyWithBox(boxStyle.copyWith(shimmer: shimmer));

  //Shadow Style
  @override
  List<GaplyShadow> get shadowStyle => boxStyle.shadows;
  @override
  T copyWithShadow(List<GaplyShadow> shadows) => copyWithBox(boxStyle.copyWith(shadows: shadows));

  //Filter Style
  @override
  GaplyFilter get filterStyle => boxStyle.filter;
  @override
  T copyWithFilter(GaplyFilter filter) => copyWithBox(boxStyle.copyWith(filter: filter));

  //Noise Style
  @override
  GaplyNoise get noiseStyle => boxStyle.noise;
  @override
  T copyWithNoise(GaplyNoise noise) => copyWithBox(boxStyle.copyWith(noise: noise));

  //Motion Style
  @override
  GaplyMotion get gaplyMotion => boxStyle.motion;
  @override
  T copyWithMotion(GaplyMotion motion) => copyWithBox(boxStyle.copyWith(motion: motion));

  //Color Style
  @override
  GaplyColor get colorStyle => boxStyle.color;
  @override
  T copyWithColor(GaplyColor color) => copyWithBox(boxStyle.copyWith(color: color));

  //BorderColor Style
  @override
  GaplyColor get borderColorStyle => boxStyle.borderColor;
  @override
  T copyWithBorderColor(GaplyColor color) => copyWithBox(boxStyle.copyWith(borderColor: color));

  T boxGlassToken(GaplyColorToken token, {double? shade, double? borderShade, double borderWidth = 1.0}) {
    final resolvedShade = shade != null ? GaplyColorShade.resolve(shade) : GaplyColorShade.s50;
    final resolvedBorderShade = borderShade != null
        ? GaplyColorShade.resolve(borderShade)
        : GaplyColorShade.s100;

    return copyWithBox(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(token: token, shade: resolvedShade),
        borderColor: boxStyle.borderColor.copyWith(token: token, shade: resolvedBorderShade),
        layout: boxStyle.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxGlass(Color? value, {double? shade, double? borderShade, double borderWidth = 1.0}) {
    final resolvedShade = shade != null ? GaplyColorShade.resolve(shade) : GaplyColorShade.s50;
    final resolvedBorderShade = borderShade != null
        ? GaplyColorShade.resolve(borderShade)
        : GaplyColorShade.s100;

    return copyWithBox(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(customColor: value, shade: resolvedShade),
        borderColor: boxStyle.borderColor.copyWith(customColor: value, shade: resolvedBorderShade),
        layout: boxStyle.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxOnPressed(VoidCallback? action) => copyWithBox(boxStyle.copyWith(onPressed: action));
  T boxDuration(Duration value) => copyWithBox(boxStyle.copyWith(duration: value));
  T boxCurve(Curve value) => copyWithBox(boxStyle.copyWith(curve: value));
}
