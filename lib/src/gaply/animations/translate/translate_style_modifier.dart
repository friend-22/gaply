import 'package:flutter/animation.dart';

import 'translate_style.dart';

mixin TranslateStyleModifier<T> {
  TranslateStyle get translateStyle;

  T copyWithTranslate(TranslateStyle translate);

  T translateStyleSet(TranslateStyle value) => copyWithTranslate(value);

  // T translatePreset(Object name, {bool? isMoved}) =>
  //     copyWithTranslate(TranslateStyle.preset(name, isMoved: isMoved));

  T translateMove(bool move) => copyWithTranslate(translateStyle.copyWith(isMoved: move));

  T move() => copyWithTranslate(translateStyle.copyWith(isMoved: true));

  T resetMove() => copyWithTranslate(translateStyle.copyWith(isMoved: false));

  T translateTo(Offset offset) => copyWithTranslate(translateStyle.copyWith(end: offset));

  T moveX(double x) => copyWithTranslate(translateStyle.copyWith(end: Offset(x, translateStyle.end.dy)));

  T moveY(double y) => copyWithTranslate(translateStyle.copyWith(end: Offset(translateStyle.end.dx, y)));

  T translateFrom(Offset offset) => copyWithTranslate(translateStyle.copyWith(begin: offset));

  T translateDuration(Duration duration) => copyWithTranslate(translateStyle.copyWith(duration: duration));

  T translateCurve(Curve curve) => copyWithTranslate(translateStyle.copyWith(curve: curve));

  T translateOnComplete(VoidCallback onComplete) =>
      copyWithTranslate(translateStyle.copyWith(onComplete: onComplete));
}
