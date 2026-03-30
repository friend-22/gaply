import 'package:flutter/animation.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'gaply_translate.dart';

mixin GaplyTranslateModifier<T> {
  GaplyTranslate get gaplyTranslate;

  T copyWithTranslate(GaplyTranslate translate);

  T translateStyle(GaplyTranslate value) => copyWithTranslate(value);

  T translateOf(Object key, {GaplyProfiler? profiler, bool? isMoved, VoidCallback? onComplete}) =>
      copyWithTranslate(GaplyTranslate.of(key, profiler: profiler, isMoved: isMoved, onComplete: onComplete));

  T translateMove(bool move) => copyWithTranslate(gaplyTranslate.copyWith(isMoved: move));

  T move() => copyWithTranslate(gaplyTranslate.copyWith(isMoved: true));

  T resetMove() => copyWithTranslate(gaplyTranslate.copyWith(isMoved: false));

  T translateTo(Offset offset) => copyWithTranslate(gaplyTranslate.copyWith(end: offset));

  T moveX(double x) => copyWithTranslate(gaplyTranslate.copyWith(end: Offset(x, gaplyTranslate.end.dy)));

  T moveY(double y) => copyWithTranslate(gaplyTranslate.copyWith(end: Offset(gaplyTranslate.end.dx, y)));

  T translateFrom(Offset offset) => copyWithTranslate(gaplyTranslate.copyWith(begin: offset));

  T translateDuration(Duration duration) => copyWithTranslate(gaplyTranslate.copyWith(duration: duration));

  T translateCurve(Curve curve) => copyWithTranslate(gaplyTranslate.copyWith(curve: curve));

  T translateOnComplete(VoidCallback onComplete) =>
      copyWithTranslate(gaplyTranslate.copyWith(onComplete: onComplete));
}
