import 'dart:ui';

import 'package:gaply/src/gaply/styles/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'text_style.dart';

mixin TextStyleModifier<T>
    on ColorStyleModifier<T>, BlurStyleModifier<T>, ShimmerStyleModifier<T>, GaplyMotionModifier<T> {
  GaplyTextStyle get textStyle;
  T copyWithText(GaplyTextStyle text);

  @override
  GaplyColor get colorStyle => textStyle.color;
  @override
  T copyWithColor(GaplyColor color) => copyWithText(textStyle.copyWith(color: color));

  //Blur Style
  @override
  GaplyBlur get blurStyle => textStyle.blur;
  @override
  T copyWithBlur(GaplyBlur blur) => copyWithText(textStyle.copyWith(blur: blur));

  //Shimmer Style
  @override
  GaplyShimmer get shimmerStyle => textStyle.shimmer;
  @override
  T copyWithShimmer(GaplyShimmer shimmer) => copyWithText(textStyle.copyWith(shimmer: shimmer));

  @override
  GaplyMotion get gaplyMotion => textStyle.motion;
  @override
  T copyWithMotion(GaplyMotion motion) => copyWithText(textStyle.copyWith(motion: motion));

  // 크기 조절 (디자인 시스템 가이드라인 반영 가능)
  T textXs() => copyWithText(textStyle.copyWith(fontSize: 12));
  T textSm() => copyWithText(textStyle.copyWith(fontSize: 14));
  T textBase() => copyWithText(textStyle.copyWith(fontSize: 16));
  T textLg() => copyWithText(textStyle.copyWith(fontSize: 20));

  // 굵기 조절
  T bold() => copyWithText(textStyle.copyWith(fontWeight: FontWeight.bold));
  T weight(FontWeight weight) => copyWithText(textStyle.copyWith(fontWeight: weight));

  // 색상 (Role 기반)
  T textColor(GaplyColor gaplyColor) => copyWithText(textStyle.copyWith(color: gaplyColor));
  T textPrimary() => textColor(const GaplyColor.fromToken(GaplyColorToken.primary));

  // 기타
  T textHeight(double value) => copyWithText(textStyle.copyWith(height: value));
  T underline() => copyWithText(textStyle.copyWith(decoration: TextDecoration.underline));
}
