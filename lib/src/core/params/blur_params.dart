import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/color_params.dart';
import 'package:gaply/src/widget/blur_widget.dart';

@immutable
class BlurParams extends ParamsBase<BlurParams> with _BlurResolutionMixin {
  final double sigma;
  final double opacity;
  final ColorParams color;

  const BlurParams({this.sigma = 0.0, this.opacity = 0.0, this.color = const ColorParams.transparent()});

  factory BlurParams.preset(String name, {ColorParams? color}) {
    final params = GaplyBlurPreset.of(name) ?? GaplyBlurPreset.of('none')!;
    return params.copyWith(color: color);
  }

  @override
  bool get isEnabled => sigma > 0 || opacity > 0;

  @override
  BlurParams copyWith({double? sigma, double? opacity, ColorParams? color}) {
    return BlurParams(
      sigma: sigma ?? this.sigma,
      opacity: opacity ?? this.opacity,
      color: color ?? this.color,
    );
  }

  @override
  BlurParams lerp(BlurParams? other, double t) {
    if (other == null) return this;

    return BlurParams(
      sigma: lerpDouble(sigma, other.sigma, t) ?? sigma,
      opacity: lerpDouble(opacity, other.opacity, t) ?? opacity,
      color: color.lerp(other.color, t),
    );
  }

  @override
  List<Object?> get props => [sigma, opacity, color];
}

mixin _BlurResolutionMixin {
  BlurParams get _params => this as BlurParams;

  ImageFilter? resolve() {
    if (!_params.isEnabled) return null;
    return ImageFilter.blur(sigmaX: _params.sigma, sigmaY: _params.sigma);
  }
}

extension BlurParamsExtension on Widget {}

class GaplyBlurPreset with GaplyPreset<BlurParams> {
  static final GaplyBlurPreset instance = GaplyBlurPreset._internal();

  GaplyBlurPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const BlurParams());

    const blurColor = ColorParams.shadow();

    add('low', const BlurParams(sigma: 4.0, opacity: 0.05, color: blurColor));
    add('medium', const BlurParams(sigma: 10.0, opacity: 0.1, color: blurColor));
    add('high', const BlurParams(sigma: 24.0, opacity: 0.2, color: blurColor));
    add('extra', const BlurParams(sigma: 48.0, opacity: 0.3, color: blurColor));

    add('apple', const BlurParams(sigma: 40.0, opacity: 0.15, color: blurColor));
    add('windows', const BlurParams(sigma: 25.0, opacity: 0.05, color: blurColor));
    add('google', const BlurParams(sigma: 8.0, opacity: 0.1, color: blurColor));
  }

  static void register(String name, BlurParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static BlurParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
