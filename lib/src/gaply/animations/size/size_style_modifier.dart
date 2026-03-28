import 'package:flutter/material.dart';

import 'size_style.dart';

mixin SizeStyleModifier<T> {
  SizeStyle get sizeStyle;

  T copyWithSize(SizeStyle size);

  T sizeStyleSet(SizeStyle value) => copyWithSize(value);

  T sizePreset(Object name, {bool? isExpanded}) =>
      copyWithSize(SizeStyle.preset(name, isExpanded: isExpanded));

  T expand() => copyWithSize(sizeStyle.copyWith(isExpanded: true));

  T collapse() => copyWithSize(sizeStyle.copyWith(isExpanded: false));

  T sizeExpanded(bool expanded) => copyWithSize(sizeStyle.copyWith(isExpanded: expanded));

  T sizeVertical() => copyWithSize(sizeStyle.copyWith(axis: Axis.vertical));

  T sizeHorizontal() => copyWithSize(sizeStyle.copyWith(axis: Axis.horizontal));

  T sizeAlignment(double alignment) => copyWithSize(sizeStyle.copyWith(axisAlignment: alignment));

  T sizeMinFactor(double factor) => copyWithSize(sizeStyle.copyWith(minFactor: factor));

  T sizeDuration(Duration duration) => copyWithSize(sizeStyle.copyWith(duration: duration));

  T sizeCurve(Curve curve) => copyWithSize(sizeStyle.copyWith(curve: curve));
}
