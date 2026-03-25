import 'package:shimmer/shimmer.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'gaply_shimmer.dart';

mixin ShimmerStyleModifier<T> {
  GaplyShimmer get shimmerStyle;

  T copyWithShimmer(GaplyShimmer shimmer);

  T shimmerStyleSet(GaplyShimmer shimmer) => copyWithShimmer(shimmer);

  T shimmerPreset(String name, {int? loop}) => copyWithShimmer(GaplyShimmer.preset(name, loop: loop));

  T shimmerSpeed(double speed) => copyWithShimmer(shimmerStyle.withSpeed(speed));

  T shimmerBaseColor(GaplyColor color) => copyWithShimmer(shimmerStyle.copyWith(baseColor: color));

  T shimmerHighlightColor(GaplyColor color) => copyWithShimmer(shimmerStyle.copyWith(highlightColor: color));

  T shimmerDirection(ShimmerDirection direction) =>
      copyWithShimmer(shimmerStyle.copyWith(direction: direction));

  T shimmerLoop(int loop) => copyWithShimmer(shimmerStyle.copyWith(loop: loop));

  T shimmerClear() => copyWithShimmer(const GaplyShimmer.none());
}
