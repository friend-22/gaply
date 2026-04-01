import 'package:flutter/material.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'gaply_gradient.dart';

mixin GaplyGradientModifier<T> {
  GaplyGradient get gaplyGradient;

  T copyWithGradient(GaplyGradient gradient);

  T gradientStyle(GaplyGradient gradient) => copyWithGradient(gradient);

  T gradientOf(Object key, {GaplyProfiler? profiler, GradientType? type}) =>
      copyWithGradient(GaplyGradient.of(key, profiler: profiler, type: type));

  T gradientType(GradientType type) => copyWithGradient(gaplyGradient.copyWith(type: type));

  T gradientColors(List<GaplyColor> colors) {
    final stops = colors.length <= 1 ? [0.0] : List.generate(colors.length, (i) => i / (colors.length - 1));
    return copyWithGradient(gaplyGradient.copyWith(colors: colors, stops: stops));
  }

  T gradientColorAt(int index, GaplyColor color) {
    if (index < 0 || index >= gaplyGradient.colors.length) return this as T;
    final newColors = List<GaplyColor>.from(gaplyGradient.colors);
    newColors[index] = color;
    return copyWithGradient(gaplyGradient.copyWith(colors: newColors));
  }

  T gradientAlign({AlignmentGeometry? begin, AlignmentGeometry? end}) =>
      copyWithGradient(gaplyGradient.copyWith(begin: begin, end: end));

  T gradientAngle({double? start, double? end}) =>
      copyWithGradient(gaplyGradient.copyWith(startAngle: start, endAngle: end));

  T gradientClear() => copyWithGradient(const GaplyGradient.none());
}
