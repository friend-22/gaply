import 'package:flutter/material.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'gaply_shake.dart';

mixin GaplyShakeModifier<T> {
  GaplyShake get gaplyShake;

  T copyWithShake(GaplyShake shake);

  T shakeStyle(GaplyShake value) => copyWithShake(value);

  T shakeOf(
    Object key, {
    GaplyProfiler? profiler,
    double? distance,
    double? count,
    bool? isVertical,
    VoidCallback? onComplete,
  }) => copyWithShake(
    GaplyShake.of(
      key,
      profiler: profiler,
      distance: distance,
      count: count,
      isVertical: isVertical,
      onComplete: onComplete,
    ),
  );

  T shakeDistance(double distance) => copyWithShake(gaplyShake.copyWith(distance: distance));

  T shakeCount(double count) => copyWithShake(gaplyShake.copyWith(count: count));

  T shakeVertical() => copyWithShake(gaplyShake.copyWith(isVertical: true));

  T shakeHorizontal() => copyWithShake(gaplyShake.copyWith(isVertical: false));

  T shakeHaptic(bool useHaptic) => copyWithShake(gaplyShake.copyWith(useHaptic: useHaptic));

  T shakeDuration(Duration duration) => copyWithShake(gaplyShake.copyWith(duration: duration));

  T shakeCurve(Curve curve) => copyWithShake(gaplyShake.copyWith(curve: curve));

  T shakeDelay(Duration delay) => copyWithShake(gaplyShake.copyWith(delay: delay));

  T shakeOnComplete(VoidCallback onComplete) => copyWithShake(gaplyShake.copyWith(onComplete: onComplete));
}
