import 'dart:ui';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'gaply_filter.dart';

mixin GaplyFilterModifier<T> {
  GaplyFilter get gaplyFilter;

  T copyWithFilter(GaplyFilter filter);

  T filterStyle(GaplyFilter filter) => copyWithFilter(filter);

  T filterOf(Object key, {GaplyProfiler? profiler}) =>
      copyWithFilter(GaplyFilter.of(key, profiler: profiler));

  T filterGrayscale(double value) => copyWithFilter(gaplyFilter.copyWith(grayscale: value));

  T filterContrast(double value) => copyWithFilter(gaplyFilter.copyWith(contrast: value));

  T filterBrightness(double value) => copyWithFilter(gaplyFilter.copyWith(brightness: value));

  T filterBlend(GaplyColor color, {BlendMode mode = BlendMode.srcATop}) =>
      copyWithFilter(gaplyFilter.copyWith(blendColor: color, blendMode: mode));

  T filterClear() => copyWithFilter(const GaplyFilter.none());
}
