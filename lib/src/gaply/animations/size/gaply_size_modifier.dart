import 'package:flutter/material.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';
import 'gaply_size.dart';

mixin GaplySizeModifier<T> {
  GaplySize get gaplySize;

  T copyWithSize(GaplySize size);

  T sizeStyle(GaplySize value) => copyWithSize(value);

  T sizeOf(
    Object key, {
    GaplyProfiler? profiler,
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
    VoidCallback? onComplete,
  }) => copyWithSize(
    GaplySize.of(
      key,
      profiler: profiler,
      axisAlignment: axisAlignment,
      isExpanded: isExpanded,
      minFactor: minFactor,
      onComplete: onComplete,
    ),
  );

  T expand() => copyWithSize(gaplySize.copyWith(isExpanded: true));

  T collapse() => copyWithSize(gaplySize.copyWith(isExpanded: false));

  T sizeExpanded(bool expanded) => copyWithSize(gaplySize.copyWith(isExpanded: expanded));

  T sizeVertical() => copyWithSize(gaplySize.copyWith(axis: Axis.vertical));

  T sizeHorizontal() => copyWithSize(gaplySize.copyWith(axis: Axis.horizontal));

  T sizeAlignment(double alignment) => copyWithSize(gaplySize.copyWith(axisAlignment: alignment));

  T sizeMinFactor(double factor) => copyWithSize(gaplySize.copyWith(minFactor: factor));

  T sizeDuration(Duration duration) => copyWithSize(gaplySize.copyWith(duration: duration));

  T sizeCurve(Curve curve) => copyWithSize(gaplySize.copyWith(curve: curve));
}
