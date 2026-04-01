import 'dart:ui';

import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'gaply_text.dart';

mixin GaplyTextModifier<T>
    on GaplyColorModifier<T>, GaplyBlurModifier<T>, GaplyShimmerModifier<T>, GaplyMotionModifier<T> {
  GaplyText get gaplyText;
  T copyWithText(GaplyText text);

  T textStyle(GaplyText gaplyText) => copyWithText(gaplyText);

  T textOf(Object key, {GaplyProfiler? profiler}) => copyWithText(GaplyText.of(key, profiler: profiler));

  @override
  GaplyColor get gaplyColor => gaplyText.color;
  @override
  T copyWithColor(GaplyColor color) => copyWithText(gaplyText.copyWith(color: color));

  //Blur Style
  @override
  GaplyBlur get gaplyBlur => gaplyText.blur;
  @override
  T copyWithBlur(GaplyBlur blur) => copyWithText(gaplyText.copyWith(blur: blur));

  //Shimmer Style
  @override
  GaplyShimmer get gaplyShimmer => gaplyText.shimmer;
  @override
  T copyWithShimmer(GaplyShimmer shimmer) => copyWithText(gaplyText.copyWith(shimmer: shimmer));

  @override
  GaplyMotion get gaplyMotion => gaplyText.motion;
  @override
  T copyWithMotion(GaplyMotion motion) => copyWithText(gaplyText.copyWith(motion: motion));

  // 크기 조절 (디자인 시스템 가이드라인 반영 가능)
  T textXs() => copyWithText(gaplyText.copyWith(fontSize: 12));
  T textSm() => copyWithText(gaplyText.copyWith(fontSize: 14));
  T textBase() => copyWithText(gaplyText.copyWith(fontSize: 16));
  T textLg() => copyWithText(gaplyText.copyWith(fontSize: 20));

  // 굵기 조절
  T bold() => copyWithText(gaplyText.copyWith(fontWeight: FontWeight.bold));
  T weight(FontWeight weight) => copyWithText(gaplyText.copyWith(fontWeight: weight));

  // 색상 (Role 기반)
  T textColor(GaplyColor gaplyColor) => copyWithText(gaplyText.copyWith(color: gaplyColor));
  T textPrimary() => textColor(const GaplyColor.fromToken(GaplyColorToken.primary));

  // 기타
  T textHeight(double value) => copyWithText(gaplyText.copyWith(height: value));
  T underline() => copyWithText(gaplyText.copyWith(decoration: TextDecoration.underline));
}
