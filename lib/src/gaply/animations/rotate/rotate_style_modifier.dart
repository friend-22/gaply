import 'package:flutter/material.dart';

import 'rotate_style.dart';

mixin RotateStyleModifier<T> {
  RotateStyle get rotateStyle;

  T copyWithRotate(RotateStyle rotate);

  T rotateStyleSet(RotateStyle value) => copyWithRotate(value);

  T rotatePreset(Object name, {bool? isRotated}) =>
      copyWithRotate(RotateStyle.preset(name, isRotated: isRotated));

  T rotateActive(bool active) => copyWithRotate(rotateStyle.copyWith(isRotated: active));

  T rotateRange({double? begin, double? end, bool? useRadians}) =>
      copyWithRotate(rotateStyle.copyWith(begin: begin, end: end, useRadians: useRadians));

  T rotateAlignment(Alignment alignment) => copyWithRotate(rotateStyle.copyWith(alignment: alignment));

  T rotateDuration(Duration duration) => copyWithRotate(rotateStyle.copyWith(duration: duration));

  T rotateCurve(Curve curve) => copyWithRotate(rotateStyle.copyWith(curve: curve));

  T rotateOnComplete(VoidCallback onComplete) => copyWithRotate(rotateStyle.copyWith(onComplete: onComplete));
}
