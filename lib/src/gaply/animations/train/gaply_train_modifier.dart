import 'package:flutter/material.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'gaply_train.dart';

mixin GaplyTrainModifier<T> {
  GaplyTrain get gaplyTrain;

  T copyWithTrain(GaplyTrain train);

  T trainStyle(GaplyTrain value) => copyWithTrain(value);

  T trainOf(Object key, {GaplyProfiler? profiler, bool? useOpacity, VoidCallback? onComplete}) =>
      copyWithTrain(GaplyTrain.of(key, profiler: profiler, useOpacity: useOpacity, onComplete: onComplete));

  T trainDirection(AxisDirection direction) => copyWithTrain(gaplyTrain.copyWith(direction: direction));

  T trainOpacity(bool useOpacity) => copyWithTrain(gaplyTrain.copyWith(useOpacity: useOpacity));

  T trainDuration(Duration duration) => copyWithTrain(gaplyTrain.copyWith(duration: duration));
  T trainCurve(Curve curve) => copyWithTrain(gaplyTrain.copyWith(curve: curve));
  T trainDelay(Duration delay) => copyWithTrain(gaplyTrain.copyWith(delay: delay));
  T trainOnComplete(VoidCallback onComplete) => copyWithTrain(gaplyTrain.copyWith(onComplete: onComplete));
}
