import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'gaply_gradient.dart';

mixin GradientStyleModifier<T> {
  GaplyGradient get gradientStyle;

  T copyWithGradient(GaplyGradient gradient);

  T gradientStyleSet(GaplyGradient gradient) => copyWithGradient(gradient);

  T gradientPreset(Object name) => copyWithGradient(GaplyGradient.preset(name));

  T gradientType(GradientType type) => copyWithGradient(gradientStyle.copyWith(type: type));

  T gradientColors(List<GaplyColor> colors) {
    final stops = colors.length <= 1 ? [0.0] : List.generate(colors.length, (i) => i / (colors.length - 1));
    return copyWithGradient(gradientStyle.copyWith(colors: colors, stops: stops));
  }

  T gradientColorAt(int index, GaplyColor color) {
    if (index < 0 || index >= gradientStyle.colors.length) return this as T;
    final newColors = List<GaplyColor>.from(gradientStyle.colors);
    newColors[index] = color;
    return copyWithGradient(gradientStyle.copyWith(colors: newColors));
  }

  T gradientAlign({AlignmentGeometry? begin, AlignmentGeometry? end}) =>
      copyWithGradient(gradientStyle.copyWith(begin: begin, end: end));

  T gradientAngle({double? start, double? end}) =>
      copyWithGradient(gradientStyle.copyWith(startAngle: start, endAngle: end));

  T gradientClear() => copyWithGradient(const GaplyGradient.none());
}
