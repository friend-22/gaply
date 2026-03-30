import 'dart:ui';

import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'gaply_filter.dart';

mixin FilterStyleModifier<T> {
  GaplyFilter get filterStyle;

  T copyWithFilter(GaplyFilter filter);

  T filterStyleSet(GaplyFilter filter) => copyWithFilter(filter);

  // T filterPreset(Object name) => copyWithFilter(GaplyFilter.preset(name));

  T filterGrayscale(double value) => copyWithFilter(filterStyle.copyWith(grayscale: value));

  T filterContrast(double value) => copyWithFilter(filterStyle.copyWith(contrast: value));

  T filterBrightness(double value) => copyWithFilter(filterStyle.copyWith(brightness: value));

  T filterBlend(GaplyColor color, {BlendMode mode = BlendMode.srcATop}) =>
      copyWithFilter(filterStyle.copyWith(blendColor: color, blendMode: mode));

  T filterClear() => copyWithFilter(const GaplyFilter.none());
}
