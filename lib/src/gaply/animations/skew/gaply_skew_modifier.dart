import 'package:flutter/animation.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'gaply_skew.dart';

mixin GaplySkewModifier<T> {
  GaplySkew get gaplySkew;

  T copyWithSkew(GaplySkew skew);

  T skewStyle(GaplySkew value) => copyWithSkew(value);

  T skewOf(Object key, {GaplyProfiler? profiler, bool? isSkewed, VoidCallback? onComplete}) =>
      copyWithSkew(GaplySkew.of(key, profiler: profiler, isSkewed: isSkewed, onComplete: onComplete));

  T skewActive(bool active) => copyWithSkew(gaplySkew.copyWith(isSkewed: active));

  T skewSet() => copyWithSkew(gaplySkew.copyWith(isSkewed: true));

  T skewReset() => copyWithSkew(gaplySkew.copyWith(isSkewed: false));

  T skewTo(double x, double y) => copyWithSkew(gaplySkew.copyWith(skew: Offset(x, y)));

  T skewX(double x) => copyWithSkew(gaplySkew.copyWith(skew: Offset(x, gaplySkew.skew.dy)));

  T skewY(double y) => copyWithSkew(gaplySkew.copyWith(skew: Offset(gaplySkew.skew.dx, y)));

  T skewDuration(Duration duration) => copyWithSkew(gaplySkew.copyWith(duration: duration));

  T skewCurve(Curve curve) => copyWithSkew(gaplySkew.copyWith(curve: curve));

  T skewOnComplete(VoidCallback onComplete) => copyWithSkew(gaplySkew.copyWith(onComplete: onComplete));
}
