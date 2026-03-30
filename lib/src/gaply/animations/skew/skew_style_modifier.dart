import 'package:flutter/animation.dart';

import 'skew_style.dart';

mixin SkewStyleModifier<T> {
  SkewStyle get skewStyle;

  T copyWithSkew(SkewStyle skew);

  T skewStyleSet(SkewStyle value) => copyWithSkew(value);

  // T skewPreset(Object name, {bool? isSkewed}) => copyWithSkew(SkewStyle.preset(name, isSkewed: isSkewed));

  T skewActive(bool active) => copyWithSkew(skewStyle.copyWith(isSkewed: active));

  T skewSet() => copyWithSkew(skewStyle.copyWith(isSkewed: true));

  T skewReset() => copyWithSkew(skewStyle.copyWith(isSkewed: false));

  T skewTo(double x, double y) => copyWithSkew(skewStyle.copyWith(skew: Offset(x, y)));

  T skewX(double x) => copyWithSkew(skewStyle.copyWith(skew: Offset(x, skewStyle.skew.dy)));

  T skewY(double y) => copyWithSkew(skewStyle.copyWith(skew: Offset(skewStyle.skew.dx, y)));

  T skewDuration(Duration duration) => copyWithSkew(skewStyle.copyWith(duration: duration));

  T skewCurve(Curve curve) => copyWithSkew(skewStyle.copyWith(curve: curve));

  T skewOnComplete(VoidCallback onComplete) => copyWithSkew(skewStyle.copyWith(onComplete: onComplete));
}
