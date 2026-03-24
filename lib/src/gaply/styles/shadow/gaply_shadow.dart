import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/color_ext.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/shadow/shadow_presets.dart';

@immutable
class GaplyShadow extends GaplyStyle<GaplyShadow> with _GShadowMixin {
  static const double _elevationOffsetScale = 1.5;
  static const double _elevationBlurScale = 0.5;
  static const double _maxAlpha = 0.5;
  static const double _minAlpha = 0.1;

  final double spreadRadius;
  final double blurRadius;
  final GaplyColor color;
  final Offset offset;
  final BlurStyle blurStyle;

  const GaplyShadow({
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

  static void register(String name, GaplyShadow style) => GaplyShadowPreset.register(name, style);

  factory GaplyShadow.preset(String name, {GaplyColor? color}) {
    final style = GaplyShadowPreset.of(name);

    if (style == null) {
      throw ArgumentError('Unknown shadow preset: "$name"');
    }

    return color != null ? style.copyWith(color: color) : style;
  }

  factory GaplyShadow.elevation(double elevation, {GaplyColor? color}) {
    if (elevation <= 0) return const GaplyShadow.none();

    final alpha = (_maxAlpha - (elevation / 100)).clamp(_minAlpha, _maxAlpha);

    return GaplyShadow(
      offset: Offset(elevation, elevation),
      blurRadius: elevation * 0.5,
      spreadRadius: -elevation / 8,
      color: color ?? const GaplyColor.shadow().opacityValue(alpha),
    );
  }

  @override
  bool get isEnabled => color.isEnabled;

  GaplyShadow withIntensity(double intensity) {
    return copyWith(blurRadius: blurRadius * intensity, spreadRadius: spreadRadius * intensity);
  }

  @override
  GaplyShadow copyWith({
    double? spreadRadius,
    double? blurRadius,
    GaplyColor? color,
    Offset? offset,
    BlurStyle? blurStyle,
  }) {
    return GaplyShadow(
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

    return GaplyShadow(
      spreadRadius: lerpDouble(spreadRadius, other.spreadRadius, t) ?? spreadRadius,
      blurRadius: lerpDouble(blurRadius, other.blurRadius, t) ?? blurRadius,
      offset: Offset.lerp(offset, other.offset, t) ?? offset,
      color: color.lerp(other.color, t),
      blurStyle: t < 0.5 ? blurStyle : other.blurStyle,
    );
  }

  @override
  List<Object?> get props => [spreadRadius, blurRadius, color, offset, blurStyle];
}

mixin _GShadowMixin {
  GaplyShadow get _params => this as GaplyShadow;

  BoxShadow? resolve(BuildContext context) {
    final resolvedColor = _params.color.resolve(context);
    if (resolvedColor == null) return null;

    return BoxShadow(
      color: resolvedColor,
      offset: _params.offset,
      blurRadius: _params.blurRadius,
      spreadRadius: _params.spreadRadius,
      blurStyle: _params.blurStyle,
    );
  }
}
