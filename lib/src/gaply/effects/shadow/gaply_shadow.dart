import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'package:gaply/src/gaply/effects/color/color_defines.dart';

import 'gaply_shadow_modifier.dart';

part 'gaply_shadow.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyShadow extends GaplyStyle<GaplyShadow> with _GaplyShadowMixin, GaplyShadowModifier<GaplyShadow> {
  // static const double _elevationOffsetScale = 1.5;
  // static const double _elevationBlurScale = 0.5;
  static const double _minOpacity = 0.1;
  static const double _maxOpacity = 0.5;

  final double spreadRadius;
  final double blurRadius;
  final GaplyColor color;
  final Offset offset;
  final BlurStyle blurStyle;

  const GaplyShadow({
    super.profiler,
    this.spreadRadius = 0.0,
    required this.blurRadius,
    required this.color,
    this.offset = Offset.zero,
    this.blurStyle = BlurStyle.normal,
  });

  const GaplyShadow.none()
    : spreadRadius = 0.0,
      blurRadius = 0.0,
      color = const GaplyColor.none(),
      offset = Offset.zero,
      blurStyle = BlurStyle.normal;

  static GaplyShadowPreset preset = GaplyShadowPreset._i;

  factory GaplyShadow.of(Object key, {GaplyProfiler? profiler, GaplyColor? color}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, color: color);
  }

  factory GaplyShadow.elevation(double elevation, {GaplyProfiler? profiler, GaplyColor? color}) {
    if (elevation <= 0) return const GaplyShadow.none();

    final opacity = (_maxOpacity - (elevation / 100)).clamp(_minOpacity, _maxOpacity);
    final resolveOpacity = GaplyColorOpacity(opacity);

    return GaplyShadow(
      profiler: profiler,
      offset: Offset(elevation, elevation),
      blurRadius: elevation * 0.5,
      spreadRadius: -elevation / 8,
      color: color ?? GaplyColor.fromToken(GaplyColorToken.shadow, opacity: resolveOpacity),
    );
  }

  @override
  GaplyShadow copyWith({
    GaplyProfiler? profiler,
    double? spreadRadius,
    double? blurRadius,
    GaplyColor? color,
    Offset? offset,
    BlurStyle? blurStyle,
  }) {
    return GaplyShadow(
      profiler: profiler ?? this.profiler,
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurStyle: blurStyle ?? this.blurStyle,
    );
  }

  @override
  GaplyShadow lerp(GaplyShadow? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyShadow(
        profiler: other.profiler,
        spreadRadius: lerpDouble(spreadRadius, other.spreadRadius, t) ?? spreadRadius,
        blurRadius: lerpDouble(blurRadius, other.blurRadius, t) ?? blurRadius,
        offset: Offset.lerp(offset, other.offset, t) ?? offset,
        color: color.lerp(other.color, t),
        blurStyle: t < 0.5 ? blurStyle : other.blurStyle,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [spreadRadius, blurRadius, color, offset, blurStyle];

  @override
  bool get hasEffect => color.hasEffect;
}

mixin _GaplyShadowMixin {
  GaplyShadow get _self => this as GaplyShadow;
  GaplyShadow get gaplyShadow => this as GaplyShadow;

  GaplyShadow copyWithShadow(GaplyShadow shadow) {
    return _self.copyWith(
      profiler: shadow.profiler,
      spreadRadius: shadow.spreadRadius,
      blurRadius: shadow.blurRadius,
      offset: shadow.offset,
      color: shadow.color,
      blurStyle: shadow.blurStyle,
    );
  }

  BoxShadow? resolve(BuildContext context) {
    if (!_self.hasEffect) return null;

    final resolvedColor = _self.profiler.trace(() => _self.color.resolve(context), tag: 'resolve');
    if (resolvedColor == null) return null;

    return BoxShadow(
      color: resolvedColor,
      offset: _self.offset,
      blurRadius: _self.blurRadius,
      spreadRadius: _self.spreadRadius,
      blurStyle: _self.blurStyle,
    );
  }
}

void _initPresets(GaplyShadowPreset preset) {
  const blurColor = GaplyColor.fromToken(GaplyColorToken.shadow);

  preset.add(
    'small',
    const GaplyShadow(spreadRadius: 0.0, blurRadius: 4.0, offset: Offset(0, 2), color: blurColor),
  );
  preset.add(
    'medium',
    const GaplyShadow(spreadRadius: -1.0, blurRadius: 10.0, offset: Offset(0, 4), color: blurColor),
  );
  preset.add(
    'large',
    const GaplyShadow(spreadRadius: -2.0, blurRadius: 24.0, offset: Offset(0, 10), color: blurColor),
  );
  preset.add(
    'base',
    const GaplyShadow(spreadRadius: 0.0, blurRadius: 5.0, offset: Offset(3, 3), color: blurColor),
  );
}
