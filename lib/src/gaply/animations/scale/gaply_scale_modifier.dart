import 'package:flutter/material.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'gaply_scale.dart';

mixin GaplyScaleModifier<T> {
  GaplyScale get gaplyScale;

  T copyWithScale(GaplyScale scale);

  T scaleStyle(GaplyScale value) => copyWithScale(value);

  T scaleOf(
    Object name, {
    GaplyProfiler? profiler,
    Alignment? alignment,
    bool? isScaled,
    VoidCallback? onComplete,
  }) => copyWithScale(
    GaplyScale.of(name, profiler: profiler, alignment: alignment, isScaled: isScaled, onComplete: onComplete),
  );

  T scaleActive(bool active) => copyWithScale(gaplyScale.copyWith(isScaled: active));

  T scaleSet() => copyWithScale(gaplyScale.copyWith(isScaled: true));

  T scaleReset() => copyWithScale(gaplyScale.copyWith(isScaled: false));

  T scaleRange({double? begin, double? end}) => copyWithScale(gaplyScale.copyWith(begin: begin, end: end));

  T scaleAlignment(Alignment alignment) => copyWithScale(gaplyScale.copyWith(alignment: alignment));

  T scaleDuration(Duration duration) => copyWithScale(gaplyScale.copyWith(duration: duration));

  T scaleCurve(Curve curve) => copyWithScale(gaplyScale.copyWith(curve: curve));

  T scaleOnComplete(VoidCallback onComplete) => copyWithScale(gaplyScale.copyWith(onComplete: onComplete));
}
