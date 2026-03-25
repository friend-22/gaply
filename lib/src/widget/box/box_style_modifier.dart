import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/styles/styles.dart';
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
        MotionStyleModifier<T> {
  BoxStyle get boxStyle;
  T copyWithStyle(BoxStyle style);

  //Layout Style
  @override
  GaplyLayout get layoutStyle => boxStyle.layout;
  @override
  T copyWithLayout(GaplyLayout layout) => copyWithStyle(boxStyle.copyWith(layout: layout));

  //Blur Style
  @override
  BlurStyle get blurStyle => boxStyle.blur;
  @override
  T copyWithBlur(BlurStyle blur) => copyWithStyle(boxStyle.copyWith(blur: blur));

  //Gradient Style
  @override
  GaplyGradient get gradientStyle => boxStyle.gradient;
  @override
  T copyWithGradient(GaplyGradient gradient) => copyWithStyle(boxStyle.copyWith(gradient: gradient));

  //Shimmer Style
  @override
  GaplyShimmer get shimmerStyle => boxStyle.shimmer;
  @override
  T copyWithShimmer(GaplyShimmer shimmer) => copyWithStyle(boxStyle.copyWith(shimmer: shimmer));

  //Shadow Style
  @override
  List<GaplyShadow> get shadowStyle => boxStyle.shadows;
  @override
  T copyWithShadow(List<GaplyShadow> shadows) => copyWithStyle(boxStyle.copyWith(shadows: shadows));

  //Filter Style
  @override
  GaplyFilter get filterStyle => boxStyle.filter;
  @override
  T copyWithFilter(GaplyFilter filter) => copyWithStyle(boxStyle.copyWith(filter: filter));

  //Noise Style
  @override
  GaplyNoise get noiseStyle => boxStyle.noise;
  @override
  T copyWithNoise(GaplyNoise noise) => copyWithStyle(boxStyle.copyWith(noise: noise));

  //Motion Style
  @override
  GaplyMotion get motionStyle => boxStyle.motion;
  @override
  T copyWithMotion(GaplyMotion motion) => copyWithStyle(boxStyle.copyWith(motion: motion));

  //Color Style
  @override
  GaplyColor get colorStyle => boxStyle.color;
  @override
  T copyWithColor(GaplyColor color) => copyWithStyle(boxStyle.copyWith(color: color));

  //BorderColor Style
  @override
  GaplyColor get borderColorStyle => boxStyle.borderColor;
  @override
  T copyWithBorderColor(GaplyColor color) => copyWithStyle(boxStyle.copyWith(borderColor: color));

  T boxGlassRole(
    ColorRole value, {
    ColorShade bgShade = ColorShade.s50,
    ColorShade borderShade = ColorShade.s100,
    double borderWidth = 1.0,
  }) {
    return copyWithStyle(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(role: value, shade: bgShade),
        borderColor: boxStyle.borderColor.copyWith(role: value, shade: borderShade),
        layout: boxStyle.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxGlass(
    Color? value, {
    ColorShade bgShade = ColorShade.s50,
    ColorShade borderShade = ColorShade.s100,
    double borderWidth = 1.0,
  }) {
    return copyWithStyle(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(customColor: value, shade: bgShade),
        borderColor: boxStyle.borderColor.copyWith(customColor: value, shade: borderShade),
        layout: boxStyle.layout.copyWith(borderWidth: borderWidth),
      ),
    );
  }

  T boxOnPressed(VoidCallback? action) => copyWithStyle(boxStyle.copyWith(onPressed: action));
  T boxDuration(Duration value) => copyWithStyle(boxStyle.copyWith(duration: value));
  T boxCurve(Curve value) => copyWithStyle(boxStyle.copyWith(curve: value));
}
