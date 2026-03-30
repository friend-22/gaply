import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/shimmer/shimmer_preset.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';

import 'shimmer_style_modifier.dart';

part 'shimmer_widget.dart';

@immutable
class GaplyShimmer extends GaplyStyle<GaplyShimmer>
    with _GaplyShimmerMixin, ShimmerStyleModifier<GaplyShimmer> {
  final Duration period;
  final ShimmerDirection direction;
  final int loop;
  final GaplyColor baseColor;
  final GaplyColor highlightColor;

  const GaplyShimmer({
    super.profiler,
    this.period = const Duration(milliseconds: 1500),
    required this.baseColor,
    required this.highlightColor,
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
  });

  const GaplyShimmer.none()
    : period = Duration.zero,
      baseColor = const GaplyColor.none(),
      highlightColor = const GaplyColor.none(),
      direction = ShimmerDirection.ltr,
      loop = 0;

  // static void register(Object key, GaplyShimmer style) => GaplyShimmerPreset.add(key, style);
  //
  // factory GaplyShimmer.preset(Object key, {GaplyProfiler? profiler, int? loop}) {
  //   final style = GaplyShimmerPreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyShimmerPreset.error("GaplyShimmer", key));
  //   }
  //   return style.copyWith(profiler: profiler, loop: loop);
  // }

  GaplyShimmer withSpeed(double speed, {GaplyProfiler? profiler}) {
    final resolvePeriod = period.inMilliseconds * speed;
    return copyWith(
      profiler: profiler,
      period: Duration(milliseconds: resolvePeriod.toInt()),
    );
  }

  @override
  GaplyShimmer copyWith({
    GaplyProfiler? profiler,
    Duration? period,
    ShimmerDirection? direction,
    int? loop,
    GaplyColor? baseColor,
    GaplyColor? highlightColor,
  }) {
    return GaplyShimmer(
      profiler: profiler ?? this.profiler,
      period: period ?? this.period,
      direction: direction ?? this.direction,
      loop: loop ?? this.loop,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  GaplyShimmer lerp(GaplyShimmer? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyShimmer(
        period: Duration(
          milliseconds: lerpDouble(
            period.inMilliseconds.toDouble(),
            other.period.inMilliseconds.toDouble(),
            t,
          )!.round(),
        ),
        direction: t < 0.5 ? direction : other.direction,
        loop: t < 0.5 ? loop : other.loop,
        baseColor: baseColor.lerp(other.baseColor, t),
        highlightColor: highlightColor.lerp(other.highlightColor, t),
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [period, direction, loop, baseColor, highlightColor];

  @override
  bool get hasEffect => period.inMilliseconds > 0 && baseColor.hasEffect && highlightColor.hasEffect;
}

mixin _GaplyShimmerMixin {
  GaplyShimmer get _self => this as GaplyShimmer;
  GaplyShimmer get shimmerStyle => _self;

  GaplyShimmer copyWithShimmer(GaplyShimmer shimmer) {
    return _self.copyWith(
      profiler: shimmer.profiler,
      period: shimmer.period,
      direction: shimmer.direction,
      loop: shimmer.loop,
      baseColor: shimmer.baseColor,
      highlightColor: shimmer.highlightColor,
    );
  }

  Widget buildWidget({required BuildContext context, required Widget child}) {
    if (!_self.hasEffect) return child;

    return _ShimmerWidget(style: _self, child: child);
  }
}
