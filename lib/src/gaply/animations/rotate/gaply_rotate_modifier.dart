import 'package:flutter/material.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';
import 'gaply_rotate.dart';

mixin GaplyRotateModifier<T> {
  GaplyRotate get gaplyRotate;

  T copyWithRotate(GaplyRotate rotate);

  T rotateStyle(GaplyRotate value) => copyWithRotate(value);

  T rotateOf(
    Object key, {
    GaplyProfiler? profiler,
    Alignment? alignment,
    bool? isRotated,
    VoidCallback? onComplete,
  }) => copyWithRotate(
    GaplyRotate.of(
      key,
      profiler: profiler,
      alignment: alignment,
      isRotated: isRotated,
      onComplete: onComplete,
    ),
  );

  T rotateActive(bool active) => copyWithRotate(gaplyRotate.copyWith(isRotated: active));

  T rotateRange({double? begin, double? end, bool? useRadians}) =>
      copyWithRotate(gaplyRotate.copyWith(begin: begin, end: end, useRadians: useRadians));

  T rotateAlignment(Alignment alignment) => copyWithRotate(gaplyRotate.copyWith(alignment: alignment));

  T rotateDuration(Duration duration) => copyWithRotate(gaplyRotate.copyWith(duration: duration));

  T rotateCurve(Curve curve) => copyWithRotate(gaplyRotate.copyWith(curve: curve));

  T rotateOnComplete(VoidCallback onComplete) => copyWithRotate(gaplyRotate.copyWith(onComplete: onComplete));
}
