import 'package:flutter/material.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';
import 'gaply_flip.dart';

mixin GaplyFlipModifier<T> {
  GaplyFlip get gaplyFlip;

  T copyWithFlip(GaplyFlip flip);

  T flipStyle(GaplyFlip value) => copyWithFlip(value);

  T flipOf(
    Object key, {
    GaplyProfiler? profiler,
    Widget? backWidget,
    bool? isFlipped,
    VoidCallback? onComplete,
  }) => copyWithFlip(
    GaplyFlip.of(
      key,
      profiler: profiler,
      backWidget: backWidget,
      isFlipped: isFlipped,
      onComplete: onComplete,
    ),
  );

  T flipToggle() => copyWithFlip(gaplyFlip.copyWith(isFlipped: !gaplyFlip.isFlipped));

  T flipSide(bool isFlipped) => copyWithFlip(gaplyFlip.copyWith(isFlipped: isFlipped));

  T flipHorizontal() => copyWithFlip(gaplyFlip.copyWith(axis: Axis.horizontal));

  T flipVertical() => copyWithFlip(gaplyFlip.copyWith(axis: Axis.vertical));

  T flipAngle(double angle) => copyWithFlip(gaplyFlip.copyWith(angleRange: angle));

  T flipBack(Widget widget) => copyWithFlip(gaplyFlip.copyWith(backWidget: widget));

  T flipDuration(Duration duration) => copyWithFlip(gaplyFlip.copyWith(duration: duration));

  T flipCurve(Curve curve) => copyWithFlip(gaplyFlip.copyWith(curve: curve));

  T flipDelay(Duration delay) => copyWithFlip(gaplyFlip.copyWith(delay: delay));

  T flipOnComplete(VoidCallback onComplete) => copyWithFlip(gaplyFlip.copyWith(onComplete: onComplete));
}
