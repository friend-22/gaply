import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:flutter/material.dart';

import 'blur_presets.dart';
import 'blur_style_modifier.dart';

part 'blur_widget.dart';

@immutable
class BlurStyle extends GaplyStyle<BlurStyle> with _BlurStyleMixin, BlurStyleModifier<BlurStyle> {
  final double sigma;
  final GaplyColor color;

  const BlurStyle({required this.sigma, this.color = const GaplyColor.transparent()})
    : assert(sigma >= 0, 'Sigma must be greater than or equal to 0.');

  const BlurStyle.none() : this(sigma: 0.0, color: const GaplyColor.none());

  static void register(String name, BlurStyle style) => GaplyBlurPreset.register(name, style);

  factory BlurStyle.preset(String name, {GaplyColor? color}) {
    final style = GaplyBlurPreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown blur preset: "$name". '
        'Available presets: ${GaplyBlurPreset.instance.allKeys.join(", ")}',
      );
    }

    return color != null ? style.copyWith(color: color) : style;
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

  @override
  bool get hasEffect => sigma > 0 && color.hasEffect;
}

mixin _BlurStyleMixin {
  BlurStyle get blurStyle => this as BlurStyle;

  BlurStyle copyWithBlur(BlurStyle blur) {
    return blurStyle.copyWith(sigma: blur.sigma, color: blur.color);
  }

  ImageFilter? resolve() {
    if (!blurStyle.hasEffect) return null;

    return ImageFilter.blur(sigmaX: blurStyle.sigma, sigmaY: blurStyle.sigma);
  }

  Widget buildWidget({
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
  }) {
    if (!blurStyle.hasEffect) return child;

    return _BlurWidget(style: blurStyle, borderRadius: borderRadius, child: child);
  }
}
