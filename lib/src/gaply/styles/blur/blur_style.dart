import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:flutter/material.dart';

import 'blur_presets.dart';

part 'blur_widget.dart';

@immutable
class BlurStyle extends GaplyStyle<BlurStyle> {
  final double sigma;
  final GaplyColor color;

  const BlurStyle({required this.sigma, this.color = const GaplyColor.transparent()})
    : assert(sigma >= 0, 'Sigma must be greater than or equal to 0.');

  const BlurStyle.none() : this(sigma: 0.0, color: const GaplyColor.none());

  static void register(String name, BlurStyle style) => GaplyBlurPreset.register(name, style);

  factory BlurStyle.preset(String name, {GaplyColor? color}) {
    final style = GaplyBlurPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown blur preset: "$name"');
    }
    return color != null ? style.copyWith(color: color) : style;
  }

  @override
  bool get isEnabled => sigma > 0 && color.isEnabled;

  BlurStyle withIntensity(double intensity) {
    return copyWith(sigma: sigma * intensity);
  }

  @override
  BlurStyle copyWith({double? sigma, GaplyColor? color}) {
    return BlurStyle(sigma: sigma ?? this.sigma, color: color ?? this.color);
  }

  @override
  BlurStyle lerp(BlurStyle? other, double t) {
    if (other == null) return this;

    return BlurStyle(sigma: lerpDouble(sigma, other.sigma, t) ?? sigma, color: color.lerp(other.color, t));
  }

  @override
  List<Object?> get props => [sigma, color];

  ImageFilter? resolve() {
    if (!isEnabled) return null;

    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }

  Widget buildWidget({
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
  }) {
    if (!isEnabled) return child;

    return _GaplyBlurWidget(style: this, borderRadius: borderRadius, child: child);
  }
}
