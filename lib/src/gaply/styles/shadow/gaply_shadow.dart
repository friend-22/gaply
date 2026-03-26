import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/color/color_defines.dart';

import 'shadow_presets.dart';
import 'shadow_style_modifier.dart';

@immutable
class GaplyShadow extends GaplyStyle<GaplyShadow> with _GaplyShadowMixin, ShadowStyleModifier<GaplyShadow> {
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
      throw ArgumentError(GaplyShadowPreset.instance.errorMessage("GaplyShadow", name));
    }
    return color != null ? style.copyWith(color: color) : style;
  }

  factory GaplyShadow.elevation(double elevation, {GaplyColor? color}) {
    if (elevation <= 0) return const GaplyShadow.none();

    final opacity = (_maxOpacity - (elevation / 100)).clamp(_minOpacity, _maxOpacity);
    final resolveOpacity = GaplyColorOpacity(opacity);

    return GaplyShadow(
      offset: Offset(elevation, elevation),
      blurRadius: elevation * 0.5,
      spreadRadius: -elevation / 8,
      color: color ?? GaplyColor.fromToken(GaplyColorToken.shadow, opacity: resolveOpacity),
    );
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

  @override
  bool get hasEffect => color.hasEffect;
}

mixin _GaplyShadowMixin {
  GaplyShadow get shadowStyle => this as GaplyShadow;

  GaplyShadow copyWithShadow(GaplyShadow shadow) {
    return shadowStyle.copyWith(
      spreadRadius: shadow.spreadRadius,
      blurRadius: shadow.blurRadius,
      offset: shadow.offset,
      color: shadow.color,
      blurStyle: shadow.blurStyle,
    );
  }

  BoxShadow? resolve(BuildContext context) {
    final resolvedColor = shadowStyle.color.resolve(context);
    if (resolvedColor == null) return null;

    return BoxShadow(
      color: resolvedColor,
      offset: shadowStyle.offset,
      blurRadius: shadowStyle.blurRadius,
      spreadRadius: shadowStyle.spreadRadius,
      blurStyle: shadowStyle.blurStyle,
    );
  }
}
