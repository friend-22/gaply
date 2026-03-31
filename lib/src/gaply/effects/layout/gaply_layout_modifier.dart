import 'package:flutter/material.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';
import 'gaply_layout.dart';

mixin GaplyLayoutModifier<T> {
  GaplyLayout get gaplyLayout;

  T copyWithLayout(GaplyLayout layout);

  T layoutStyle(GaplyLayout value) => copyWithLayout(value);

  T layoutOf(Object key, {GaplyProfiler? profiler}) =>
      copyWithLayout(GaplyLayout.of(key, profiler: profiler));

  T layoutWidth(double value) => copyWithLayout(gaplyLayout.copyWith(width: value));

  T layoutHeight(double value) => copyWithLayout(gaplyLayout.copyWith(height: value));

  T layoutSize(double? w, double? h) => copyWithLayout(gaplyLayout.copyWith(width: w, height: h));

  T layoutPadding(EdgeInsetsGeometry value) => copyWithLayout(gaplyLayout.copyWith(padding: value));

  T layoutMargin(EdgeInsetsGeometry value) => copyWithLayout(gaplyLayout.copyWith(margin: value));

  T layoutAlignment(AlignmentGeometry value) => copyWithLayout(gaplyLayout.copyWith(alignment: value));

  T layoutScale(double value) => copyWithLayout(gaplyLayout.copyWith(scale: value));

  T layoutRadius(double value) =>
      copyWithLayout(gaplyLayout.copyWith(borderRadius: BorderRadius.circular(value)));

  T layoutBorderWidth(double width) => copyWithLayout(gaplyLayout.copyWith(borderWidth: width));

  T layoutBorderNone() => copyWithLayout(gaplyLayout.copyWith(borderWidth: 0.0));
}
