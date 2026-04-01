import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:gaply/src/inner_gaply_base.dart';

import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'package:gaply/src/gaply/effects/color/color_defines.dart';

import 'gaply_blur_modifier.dart';

part 'blur_widget.dart';
part 'gaply_blur.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyBlur extends GaplyStyle<GaplyBlur> with _BlurStyleMixin, GaplyBlurModifier<GaplyBlur> {
  final double sigma;
  final GaplyColor color;

  const GaplyBlur({super.profiler, required this.sigma, this.color = const GaplyColor.transparent()})
    : assert(sigma >= 0, 'Sigma must be greater than or equal to 0.');

  const GaplyBlur.none() : this(sigma: 0.0, color: const GaplyColor.none());

  static GaplyBlurPreset preset = GaplyBlurPreset._i;

  factory GaplyBlur.of(Object key, {GaplyProfiler? profiler, GaplyColor? color}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, color: color);
  }

  @override
  GaplyBlur copyWith({GaplyProfiler? profiler, double? sigma, GaplyColor? color}) {
    return GaplyBlur(
      profiler: profiler ?? this.profiler,
      sigma: sigma ?? this.sigma,
      color: color ?? this.color,
    );
  }

  @override
  GaplyBlur lerp(GaplyBlur? other, double t) {
    if (other == null) return this;

    return profiler.trace(
      () => GaplyBlur(
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
  GaplyBlur get _self => this as GaplyBlur;

  GaplyBlur get gaplyBlur => _self;

  GaplyBlur copyWithBlur(GaplyBlur blur) {
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

void _initPresets(GaplyBlurPreset preset) {
  const blurLowColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o10);
  const blurMediumColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o20);
  const blurHighColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o30);
  const blurExtraColor = GaplyColor.fromToken(GaplyColorToken.shadow, opacity: GaplyColorOpacity.o40);

  preset.add('low', const GaplyBlur(sigma: 4.0, color: blurLowColor));
  preset.add('medium', const GaplyBlur(sigma: 10.0, color: blurMediumColor));
  preset.add('high', const GaplyBlur(sigma: 24.0, color: blurHighColor));
  preset.add('extra', const GaplyBlur(sigma: 48.0, color: blurExtraColor));

  preset.add('apple', const GaplyBlur(sigma: 12.0, color: blurLowColor));
  preset.add('windows', const GaplyBlur(sigma: 20.0, color: blurLowColor));
  preset.add('google', const GaplyBlur(sigma: 25.0, color: blurLowColor));
}
