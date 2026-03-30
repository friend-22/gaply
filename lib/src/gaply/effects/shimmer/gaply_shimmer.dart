import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'package:gaply/src/gaply/effects/color/color_defines.dart';

import 'gaply_shimmer_modifier.dart';

part 'shimmer_widget.dart';
part 'gaply_shimmer.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyShimmer extends GaplyStyle<GaplyShimmer>
    with _GaplyShimmerMixin, GaplyShimmerModifier<GaplyShimmer> {
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

  static GaplyShimmerPreset preset = GaplyShimmerPreset._i;

  factory GaplyShimmer.of(Object key, {GaplyProfiler? profiler, int? loop}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, loop: loop);
  }

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
  GaplyShimmer get gaplyShimmer => _self;

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

void _initPresets(GaplyShimmerPreset preset) {
  preset.add(
    'light',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
    ),
  );
  preset.add(
    'dark',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s800),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s700),
    ),
  );
  preset.add(
    'primary',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o20),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.primary, opacity: GaplyColorOpacity.o40),
    ),
  );
  preset.add(
    'secondary',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o20),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.secondary, opacity: GaplyColorOpacity.o40),
    ),
  );
  preset.add(
    'error',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o10),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.error, opacity: GaplyColorOpacity.o20),
    ),
  );
  preset.add(
    'skeleton',
    const GaplyShimmer(
      period: Duration(milliseconds: 2000),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
    ),
  );
  preset.add(
    'image',
    const GaplyShimmer(
      period: Duration(milliseconds: 1200),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s300),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
    ),
  );
  preset.add(
    'text',
    const GaplyShimmer(
      period: Duration(milliseconds: 1500),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s200),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
    ),
  );
  preset.add(
    'card',
    const GaplyShimmer(
      period: Duration(milliseconds: 1800),
      baseColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s100),
      highlightColor: GaplyColor.fromToken(GaplyColorToken.surfaceVariant, shade: GaplyColorShade.s50),
    ),
  );
}
