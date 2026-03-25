import 'package:flutter/material.dart';

import 'train_style.dart';

mixin TrainStyleModifier<T> {
  TrainStyle get trainStyle;

  T copyWithTrain(TrainStyle train);

  T trainStyleSet(TrainStyle value) => copyWithTrain(value);

  T trainPreset(String name) => copyWithTrain(TrainStyle.preset(name));

  T trainDirection(AxisDirection direction) => copyWithTrain(trainStyle.copyWith(direction: direction));

  T trainOpacity(bool useOpacity) => copyWithTrain(trainStyle.copyWith(useOpacity: useOpacity));

  T trainDuration(Duration duration) => copyWithTrain(trainStyle.copyWith(duration: duration));
  T trainCurve(Curve curve) => copyWithTrain(trainStyle.copyWith(curve: curve));
  T trainDelay(Duration delay) => copyWithTrain(trainStyle.copyWith(delay: delay));
  T trainOnComplete(VoidCallback onComplete) => copyWithTrain(trainStyle.copyWith(onComplete: onComplete));
}
