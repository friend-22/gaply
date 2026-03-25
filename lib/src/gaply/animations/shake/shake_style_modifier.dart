import 'package:flutter/material.dart';

import 'shake_style.dart';

mixin ShakeStyleModifier<T> {
  ShakeStyle get shakeStyle;

  T copyWithShake(ShakeStyle shake);

  T shakeStyleSet(ShakeStyle value) => copyWithShake(value);

  T shakePreset(String name) => copyWithShake(ShakeStyle.preset(name));

  T shakeDistance(double distance) => copyWithShake(shakeStyle.copyWith(distance: distance));

  T shakeCount(double count) => copyWithShake(shakeStyle.copyWith(count: count));

  T shakeVertical() => copyWithShake(shakeStyle.copyWith(isVertical: true));

  T shakeHorizontal() => copyWithShake(shakeStyle.copyWith(isVertical: false));

  T shakeHaptic(bool useHaptic) => copyWithShake(shakeStyle.copyWith(useHaptic: useHaptic));

  T shakeDuration(Duration duration) => copyWithShake(shakeStyle.copyWith(duration: duration));

  T shakeCurve(Curve curve) => copyWithShake(shakeStyle.copyWith(curve: curve));

  T shakeDelay(Duration delay) => copyWithShake(shakeStyle.copyWith(delay: delay));

  T shakeOnComplete(VoidCallback onComplete) => copyWithShake(shakeStyle.copyWith(onComplete: onComplete));
}
