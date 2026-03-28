import 'package:flutter/material.dart';

import 'flip_style.dart';

mixin FlipStyleModifier<T> {
  FlipStyle get flipStyle;

  T copyWithFlip(FlipStyle flip);

  T flipSet(FlipStyle value) => copyWithFlip(value);

  T flipPreset(Object name) => copyWithFlip(FlipStyle.preset(name));

  T flipToggle() => copyWithFlip(flipStyle.copyWith(isFlipped: !flipStyle.isFlipped));

  T flipSide(bool isFlipped) => copyWithFlip(flipStyle.copyWith(isFlipped: isFlipped));

  T flipHorizontal() => copyWithFlip(flipStyle.copyWith(axis: Axis.horizontal));

  T flipVertical() => copyWithFlip(flipStyle.copyWith(axis: Axis.vertical));

  T flipAngle(double angle) => copyWithFlip(flipStyle.copyWith(angleRange: angle));

  T flipBack(Widget widget) => copyWithFlip(flipStyle.copyWith(backWidget: widget));

  T flipDuration(Duration duration) => copyWithFlip(flipStyle.copyWith(duration: duration));

  T flipCurve(Curve curve) => copyWithFlip(flipStyle.copyWith(curve: curve));

  T flipDelay(Duration delay) => copyWithFlip(flipStyle.copyWith(delay: delay));

  T flipOnComplete(VoidCallback onComplete) => copyWithFlip(flipStyle.copyWith(onComplete: onComplete));
}
