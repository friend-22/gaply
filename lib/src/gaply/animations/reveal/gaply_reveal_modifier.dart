import 'package:flutter/material.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'gaply_reveal.dart';

mixin GaplyRevealModifier<T> {
  GaplyReveal get gaplyReveal;

  T copyWithReveal(GaplyReveal reveal);

  T revealStyle(GaplyReveal value) => copyWithReveal(value);

  T revealOf(
    Object key, {
    GaplyProfiler? profiler,
    bool? isVisible,
    bool? fixedSize,
    bool? useFade,
    VoidCallback? onComplete,
  }) => copyWithReveal(
    GaplyReveal.of(
      key,
      profiler: profiler,
      isVisible: isVisible,
      fixedSize: fixedSize,
      useFade: useFade,
      onComplete: onComplete,
    ),
  );

  T revealVisible(bool visible) => copyWithReveal(gaplyReveal.copyWith(isVisible: visible));

  T revealDirection(AxisDirection direction) => copyWithReveal(gaplyReveal.copyWith(direction: direction));

  T revealFixedSize(bool fixed) => copyWithReveal(gaplyReveal.copyWith(fixedSize: fixed));

  T revealUseFade(bool useFade) => copyWithReveal(gaplyReveal.copyWith(useFade: useFade));

  T revealDuration(Duration duration) => copyWithReveal(gaplyReveal.copyWith(duration: duration));

  T revealCurve(Curve curve) => copyWithReveal(gaplyReveal.copyWith(curve: curve));

  T revealDelay(Duration delay) => copyWithReveal(gaplyReveal.copyWith(delay: delay));

  T revealOnComplete(VoidCallback onComplete) => copyWithReveal(gaplyReveal.copyWith(onComplete: onComplete));
}
