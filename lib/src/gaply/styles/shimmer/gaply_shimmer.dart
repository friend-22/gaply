import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/shimmer/shimmer_presets.dart';
import 'package:shimmer/shimmer.dart';

@immutable
class GaplyShimmer extends GaplyStyle<GaplyShimmer> with _GShimmerMixin {
  final Duration period;
  final ShimmerDirection direction;
  final int loop;
  final GaplyColor baseColor;
  final GaplyColor highlightColor;

  const GaplyShimmer({
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

  static void register(String name, GaplyShimmer style) => GaplyShimmerPreset.register(name, style);

  factory GaplyShimmer.preset(String name, {int? loop}) {
    final style = GaplyShimmerPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown shimmer preset: "$name"');
    }
    return loop != null ? style.copyWith(loop: loop) : style;
  }

  GaplyShimmer withSpeed(double speed) {
    final resolvePeriod = period.inMilliseconds * speed;
    return copyWith(period: Duration(milliseconds: resolvePeriod.toInt()));
  }

  @override
  bool get isEnabled => period.inMilliseconds > 0 && baseColor.isEnabled && highlightColor.isEnabled;

  @override
  GaplyShimmer copyWith({
    Duration? period,
    ShimmerDirection? direction,
    int? loop,
    GaplyColor? baseColor,
    GaplyColor? highlightColor,
  }) {
    return GaplyShimmer(
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
  }

  @override
  List<Object?> get props => [period, direction, loop, baseColor, highlightColor];
}

mixin _GShimmerMixin {
  GaplyShimmer get _params => this as GaplyShimmer;

  Widget buildWidget({required BuildContext context, required Widget child}) {
    if (!_params.isEnabled) return child;

    final baseColor = _params.baseColor.resolve(context);
    final highlightColor = _params.highlightColor.resolve(context);

    if (baseColor == null || highlightColor == null) return child;

    return Shimmer.fromColors(
      period: _params.period,
      direction: _params.direction,
      loop: _params.loop,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}
