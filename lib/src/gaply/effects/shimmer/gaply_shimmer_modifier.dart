import 'package:shimmer/shimmer.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'gaply_shimmer.dart';

mixin GaplyShimmerModifier<T> {
  GaplyShimmer get gaplyShimmer;

  T copyWithShimmer(GaplyShimmer shimmer);

  T shimmerStyle(GaplyShimmer shimmer) => copyWithShimmer(shimmer);

  T shimmerOf(Object key, {GaplyProfiler? profiler, int? loop}) =>
      copyWithShimmer(GaplyShimmer.of(key, profiler: profiler, loop: loop));

  T shimmerSpeed(double speed) => copyWithShimmer(gaplyShimmer.withSpeed(speed));

  T shimmerBaseColor(GaplyColor color) => copyWithShimmer(gaplyShimmer.copyWith(baseColor: color));

  T shimmerHighlightColor(GaplyColor color) => copyWithShimmer(gaplyShimmer.copyWith(highlightColor: color));

  T shimmerDirection(ShimmerDirection direction) =>
      copyWithShimmer(gaplyShimmer.copyWith(direction: direction));

  T shimmerLoop(int loop) => copyWithShimmer(gaplyShimmer.copyWith(loop: loop));

  T shimmerClear() => copyWithShimmer(const GaplyShimmer.none());
}
