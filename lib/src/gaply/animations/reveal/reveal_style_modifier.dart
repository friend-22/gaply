import 'package:flutter/material.dart';

import 'reveal_style.dart';

mixin RevealStyleModifier<T> {
  RevealStyle get revealStyle;

  T copyWithReveal(RevealStyle reveal);

  T revealStyleSet(RevealStyle value) => copyWithReveal(value);

  T revealPreset(String name, {bool? isVisible}) =>
      copyWithReveal(RevealStyle.preset(name, isVisible: isVisible));

  T revealVisible(bool visible) => copyWithReveal(revealStyle.copyWith(isVisible: visible));

  T revealDirection(AxisDirection direction) => copyWithReveal(revealStyle.copyWith(direction: direction));

  T revealFixedSize(bool fixed) => copyWithReveal(revealStyle.copyWith(fixedSize: fixed));

  T revealUseFade(bool useFade) => copyWithReveal(revealStyle.copyWith(useFade: useFade));

  T revealDuration(Duration duration) => copyWithReveal(revealStyle.copyWith(duration: duration));

  T revealCurve(Curve curve) => copyWithReveal(revealStyle.copyWith(curve: curve));

  T revealDelay(Duration delay) => copyWithReveal(revealStyle.copyWith(delay: delay));

  T revealOnComplete(VoidCallback onComplete) => copyWithReveal(revealStyle.copyWith(onComplete: onComplete));
}
