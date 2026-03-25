import 'package:flutter/material.dart';

import 'gaply_layout.dart';

mixin LayoutStyleModifier<T> {
  GaplyLayout get layoutStyle;

  T copyWithLayout(GaplyLayout layout);

  T layoutStyleSet(GaplyLayout value) => copyWithLayout(value);

  T layoutPreset(String name) => copyWithLayout(GaplyLayout.preset(name));

  T layoutWidth(double value) => copyWithLayout(layoutStyle.copyWith(width: value));

  T layoutHeight(double value) => copyWithLayout(layoutStyle.copyWith(height: value));

  T layoutSize(double? w, double? h) => copyWithLayout(layoutStyle.copyWith(width: w, height: h));

  T layoutPadding(EdgeInsetsGeometry value) => copyWithLayout(layoutStyle.copyWith(padding: value));

  T layoutMargin(EdgeInsetsGeometry value) => copyWithLayout(layoutStyle.copyWith(margin: value));

  T layoutAlignment(AlignmentGeometry value) => copyWithLayout(layoutStyle.copyWith(alignment: value));

  T layoutRadius(BorderRadiusGeometry value) => copyWithLayout(layoutStyle.copyWith(borderRadius: value));

  T layoutScale(double value) => copyWithLayout(layoutStyle.copyWith(scale: value));
}
