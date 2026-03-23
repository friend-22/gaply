import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/color_params.dart';

@immutable
class BlurParams extends ParamsBase<BlurParams> with _BlurResolutionMixin {
  final double sigma;
  final ColorParams color;

  const BlurParams({required this.sigma, this.color = const ColorParams.transparent()})
    : assert(sigma >= 0, 'Sigma must be greater than or equal to 0.');

  const BlurParams.none() : this(sigma: 0.0, color: const ColorParams.none());

  factory BlurParams.preset(String name, {ColorParams? color}) {
    final params = GaplyBlurPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown blur preset: "$name"');
    }
    return color != null ? params.copyWith(color: color) : params;
  }

  @override
  bool get isEnabled => sigma > 0 && color.isEnabled;

  BlurParams withIntensity(double intensity) {
    return copyWith(sigma: sigma * intensity);
  }

  @override
  BlurParams copyWith({double? sigma, ColorParams? color}) {
    return BlurParams(sigma: sigma ?? this.sigma, color: color ?? this.color);
  }

  @override
  BlurParams lerp(BlurParams? other, double t) {
    if (other == null) return this;

    return BlurParams(sigma: lerpDouble(sigma, other.sigma, t) ?? sigma, color: color.lerp(other.color, t));
  }

  @override
  List<Object?> get props => [sigma, color];
}

mixin _BlurResolutionMixin {
  BlurParams get _params => this as BlurParams;

  ImageFilter? resolve() {
    if (!_params.isEnabled) return null;
    return ImageFilter.blur(sigmaX: _params.sigma, sigmaY: _params.sigma);
  }

  Widget buildWidget({
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
  }) {
    if (!_params.isEnabled) return child;

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: _params.resolve()!,
              child: Container(color: _params.color.resolve(context)),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

extension BlurParamsExtension on Widget {
  Widget withBlur(BuildContext context, BlurParams params, {BorderRadiusGeometry? borderRadius}) {
    return params.buildWidget(context: context, borderRadius: borderRadius, child: this);
  }
}

class GaplyBlurPreset with GaplyPreset<BlurParams> {
  static final GaplyBlurPreset instance = GaplyBlurPreset._internal();

  GaplyBlurPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    const blurLowColor = ColorParams.shadow(opacity: ColorOpacity.o10);
    const blurMediumColor = ColorParams.shadow(opacity: ColorOpacity.o20);
    const blurHighColor = ColorParams.shadow(opacity: ColorOpacity.o30);
    const blurExtraColor = ColorParams.shadow(opacity: ColorOpacity.o40);

    add('low', const BlurParams(sigma: 4.0, color: blurLowColor));
    add('medium', const BlurParams(sigma: 10.0, color: blurMediumColor));
    add('high', const BlurParams(sigma: 24.0, color: blurHighColor));
    add('extra', const BlurParams(sigma: 48.0, color: blurExtraColor));

    add('apple', const BlurParams(sigma: 12.0, color: blurLowColor));
    add('windows', const BlurParams(sigma: 20.0, color: blurLowColor));
    add('google', const BlurParams(sigma: 25.0, color: blurLowColor));
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
