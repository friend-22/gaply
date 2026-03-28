import 'package:flutter/material.dart';

import 'scale_style.dart';

mixin ScaleStyleModifier<T> {
  ScaleStyle get scaleStyle;
  T copyWithScale(ScaleStyle scale);

  T scaleStyleSet(ScaleStyle value) => copyWithScale(value);

  T scalePreset(Object name, {bool? isScaled}) => copyWithScale(ScaleStyle.preset(name, isScaled: isScaled));

  T scaleActive(bool active) => copyWithScale(scaleStyle.copyWith(isScaled: active));

  T scaleSet() => copyWithScale(scaleStyle.copyWith(isScaled: true));

  T scaleReset() => copyWithScale(scaleStyle.copyWith(isScaled: false));

  T scaleRange({double? begin, double? end}) => copyWithScale(scaleStyle.copyWith(begin: begin, end: end));

  T scaleAlignment(Alignment alignment) => copyWithScale(scaleStyle.copyWith(alignment: alignment));

  T scaleDuration(Duration duration) => copyWithScale(scaleStyle.copyWith(duration: duration));

  T scaleCurve(Curve curve) => copyWithScale(scaleStyle.copyWith(curve: curve));

  T scaleOnComplete(VoidCallback onComplete) => copyWithScale(scaleStyle.copyWith(onComplete: onComplete));
}
