import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';

import 'color_params.dart';

@immutable
class ShadowParams extends ParamsBase<ShadowParams> with _ShadowParamsMixin {
  static const double _elevationOffsetScale = 1.5;
  static const double _elevationBlurScale = 0.5;
  static const double _maxAlpha = 0.5;
  static const double _minAlpha = 0.1;

  final double spreadRadius;
  final double blurRadius;
  final ColorParams color;
  final Offset offset;
  final BlurStyle blurStyle;

  const ShadowParams({
    this.spreadRadius = 0.0,
    required this.blurRadius,
    required this.color,
    this.offset = Offset.zero,
    this.blurStyle = BlurStyle.normal,
  });

  const ShadowParams.none()
    : spreadRadius = 0.0,
      blurRadius = 0.0,
      color = const ColorParams.none(),
      offset = Offset.zero,
      blurStyle = BlurStyle.normal;

  factory ShadowParams.preset(String name, {ColorParams? color}) {
    final params = GaplyShadowPreset.of(name);

    if (params == null) {
      throw ArgumentError('Unknown shadow preset: "$name"');
    }

    return color != null ? params.copyWith(color: color) : params;
  }

  factory ShadowParams.elevation(double elevation, {ColorParams? color}) {
    if (elevation <= 0) return const ShadowParams.none();

    final alpha = (_maxAlpha - (elevation / 100)).clamp(_minAlpha, _maxAlpha);

    return ShadowParams(
      offset: Offset(elevation, elevation),
      blurRadius: elevation * 0.5,
      spreadRadius: -elevation / 8,
      color: color ?? const ColorParams.shadow().opacityValue(alpha),
    );
  }

  @override
  bool get isEnabled => color.isEnabled;

  ShadowParams withIntensity(double intensity) {
    return copyWith(blurRadius: blurRadius * intensity, spreadRadius: spreadRadius * intensity);
  }

  @override
  ShadowParams copyWith({
    double? spreadRadius,
    double? blurRadius,
    ColorParams? color,
    Offset? offset,
    BlurStyle? blurStyle,
  }) {
    return ShadowParams(
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurRadius: blurRadius ?? this.blurRadius,
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurStyle: blurStyle ?? this.blurStyle,
    );
  }

  @override
  ShadowParams lerp(ShadowParams? other, double t) {
    if (other == null) return this;

    return ShadowParams(
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

mixin _ShadowParamsMixin {
  ShadowParams get _params => this as ShadowParams;

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

class GaplyShadowPreset with GaplyPreset<ShadowParams> {
  static final GaplyShadowPreset instance = GaplyShadowPreset._internal();
  GaplyShadowPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    const blurColor = ColorParams.shadow();

    add(
      'small',
      const ShadowParams(spreadRadius: 0.0, blurRadius: 4.0, offset: Offset(0, 2), color: blurColor),
    );
    add(
      'medium',
      const ShadowParams(spreadRadius: -1.0, blurRadius: 10.0, offset: Offset(0, 4), color: blurColor),
    );
    add(
      'large',
      const ShadowParams(spreadRadius: -2.0, blurRadius: 24.0, offset: Offset(0, 10), color: blurColor),
    );
    add(
      'base',
      const ShadowParams(spreadRadius: 0.0, blurRadius: 5.0, offset: Offset(3, 3), color: blurColor),
    );
  }

  static void register(String name, ShadowParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static ShadowParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
