import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:shimmer/shimmer.dart';

import 'color_params.dart';

@immutable
class ShimmerParams extends ParamsBase<ShimmerParams> {
  final Duration period;
  final ShimmerDirection direction;
  final int loop;
  final ColorParams baseColor;
  final ColorParams highlightColor;

  const ShimmerParams({
    this.period = Duration.zero,
    this.baseColor = const ColorParams.transparent(),
    this.highlightColor = const ColorParams.transparent(),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
  });

  factory ShimmerParams.preset(String name, {int loop = 0}) {
    final params = GaplyShimmerPreset.of(name) ?? GaplyShimmerPreset.of('none')!;
    return params.copyWith(loop: loop);
  }

  @override
  bool get isEnabled => period.inMilliseconds > 0;

  @override
  ShimmerParams copyWith({
    Duration? period,
    ShimmerDirection? direction,
    int? loop,
    ColorParams? baseColor,
    ColorParams? highlightColor,
  }) {
    return ShimmerParams(
      period: period ?? this.period,
      direction: direction ?? this.direction,
      loop: loop ?? this.loop,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ShimmerParams lerp(ShimmerParams? other, double t) {
    if (other == null) return this;

    return ShimmerParams(
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

  Widget buildWidget({required BuildContext context, required Widget child}) {
    final baseColor = this.baseColor.resolve(context);
    final highlightColor = this.highlightColor.resolve(context);

    return Shimmer.fromColors(
      period: period,
      direction: direction,
      loop: loop,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

extension ShimmerExtension on Widget {
  Widget withShimmer(BuildContext context, ShimmerParams params, {bool enabled = true}) {
    if (!enabled || !params.isEnabled) return this;

    final baseColor = params.baseColor.resolve(context);
    final highlightColor = params.highlightColor.resolve(context);

    return Shimmer.fromColors(
      period: params.period,
      direction: params.direction,
      loop: params.loop,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: this,
    );
  }

  Widget shimmerPreset(BuildContext context, String name, {bool enabled = true}) {
    return withShimmer(context, ShimmerParams.preset(name), enabled: enabled);
  }
}

class GaplyShimmerPreset with GaplyPreset<ShimmerParams> {
  static final GaplyShimmerPreset instance = GaplyShimmerPreset._internal();
  GaplyShimmerPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const ShimmerParams());
    add(
      'light',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
    add(
      'dark',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s800),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s700),
      ),
    );
    add(
      'primary',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.primary, opacity: ColorOpacity.o20),
        highlightColor: ColorParams(role: ColorRole.primary, opacity: ColorOpacity.o40),
      ),
    );
    add(
      'secondary',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.secondary, opacity: ColorOpacity.o20),
        highlightColor: ColorParams(role: ColorRole.secondary, opacity: ColorOpacity.o40),
      ),
    );
    add(
      'error',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.error, opacity: ColorOpacity.o10),
        highlightColor: ColorParams(role: ColorRole.error, opacity: ColorOpacity.o20),
      ),
    );
    add(
      'skeleton',
      const ShimmerParams(
        period: Duration(milliseconds: 2000),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'fast',
      const ShimmerParams(
        period: Duration(milliseconds: 800),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
    add(
      'slow',
      const ShimmerParams(
        period: Duration(milliseconds: 2500),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
    add(
      'image',
      const ShimmerParams(
        period: Duration(milliseconds: 1200),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s300),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'text',
      const ShimmerParams(
        period: Duration(milliseconds: 1500),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s200),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s100),
      ),
    );
    add(
      'card',
      const ShimmerParams(
        period: Duration(milliseconds: 1800),
        baseColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s100),
        highlightColor: ColorParams(role: ColorRole.surfaceVariant, shade: ColorShade.s50),
      ),
    );
  }

  static void register(String name, ShimmerParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static ShimmerParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
