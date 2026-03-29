import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'blur_presets.dart';
import 'blur_style_modifier.dart';

part 'blur_widget.dart';

@immutable
class BlurStyle extends GaplyStyle<BlurStyle> with _BlurStyleMixin, BlurStyleModifier<BlurStyle> {
  final double sigma;
  final GaplyColor color;

  const BlurStyle({super.profiler, required this.sigma, this.color = const GaplyColor.transparent()})
    : assert(sigma >= 0, 'Sigma must be greater than or equal to 0.');

  const BlurStyle.none() : this(sigma: 0.0, color: const GaplyColor.none());

  static void register(Object name, BlurStyle style) => GaplyBlurPreset.add(name, style);

  factory BlurStyle.preset(Object name, {GaplyProfiler? profiler, GaplyColor? color}) {
    final style = GaplyBlurPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyBlurPreset.instance.errorMessage("BlurStyle", name));
    }
    return style.copyWith(profiler: profiler, color: color);
  }

  @override
  BlurStyle copyWith({GaplyProfiler? profiler, double? sigma, GaplyColor? color}) {
    return BlurStyle(
      profiler: profiler ?? this.profiler,
      sigma: sigma ?? this.sigma,
      color: color ?? this.color,
    );
  }

  @override
  BlurStyle lerp(BlurStyle? other, double t) {
    if (other == null) return this;

    return profiler.trace(
      () => BlurStyle(
        profiler: other.profiler,
        sigma: (lerpDouble(sigma, other.sigma, t) ?? sigma).clamp(0.0, double.infinity),
        color: color.lerp(other.color, t),
      ),
      tag: 'lerp',
    );
  }

  @override
  bool get hasEffect => sigma > 0 && color.hasEffect;

  @override
  List<Object?> get props => [sigma, color];
}

mixin _BlurStyleMixin {
  BlurStyle get _self => this as BlurStyle;

  BlurStyle get blurStyle => _self;

  BlurStyle copyWithBlur(BlurStyle blur) {
    return _self.copyWith(profiler: blur.profiler, sigma: blur.sigma, color: blur.color);
  }

  ImageFilter? resolve() {
    if (!_self.hasEffect) return null;

    return _self.profiler.trace(
      () => ImageFilter.blur(sigmaX: _self.sigma, sigmaY: _self.sigma),
      tag: 'resolve',
    );
  }

  Widget buildWidget({
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
  }) {
    if (!_self.hasEffect) return child;

    return _BlurWidget(style: _self, borderRadius: borderRadius, child: child);
  }
}
