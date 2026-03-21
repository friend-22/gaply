import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/fade_widget.dart';
import '../base/animation_params.dart';

@immutable
class FadeParams extends AnimationParams {
  final bool visible;

  const FadeParams({super.duration, super.curve = Curves.easeInOut, super.onComplete, this.visible = true});

  factory FadeParams.preset(String name, {bool? visible}) {
    final params = GaplyFadePreset.of(name) ?? GaplyFadePreset.of('none')!;
    return params.copyWith(visible: visible);
  }

  factory FadeParams.fast(String name, {bool? visible}) {
    final params = GaplyFadePreset.of(name) ?? GaplyFadePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 300), visible: visible);
  }

  factory FadeParams.slow(String name, {bool? visible}) {
    final params = GaplyFadePreset.of(name) ?? GaplyFadePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 800), visible: visible);
  }

  factory FadeParams.elastic({Duration duration = const Duration(milliseconds: 400), bool visible = true}) {
    return FadeParams(duration: duration, curve: Curves.elasticOut, visible: visible);
  }

  factory FadeParams.bounce({Duration duration = const Duration(milliseconds: 500), bool visible = true}) {
    return FadeParams(duration: duration, curve: Curves.bounceOut, visible: visible);
  }

  @override
  FadeParams copyWith({Duration? duration, Curve? curve, VoidCallback? onComplete, bool? visible}) {
    return FadeParams(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      visible: visible ?? this.visible,
    );
  }

  @override
  FadeParams lerp(AnimationParams? other, double t) {
    if (other is! FadeParams) return this;
    return FadeParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      visible: t < 0.5 ? visible : other.visible,
      onComplete: other.onComplete,
    );
  }

  @override
  List<Object?> get props => [...super.props, visible];

  Widget buildWidget({required Widget child}) {
    return FadeWidget(params: this, child: child);
  }
}

extension FadeParamsExtension on Widget {
  Widget withFade(FadeParams params) => FadeWidget(params: params, child: this);
}

class GaplyFadePreset with GaplyPreset<FadeParams> {
  static final GaplyFadePreset instance = GaplyFadePreset._internal();
  GaplyFadePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const FadeParams(duration: Duration.zero));
    add('fadeIn', const FadeParams(curve: Curves.easeInOut));
    add('fadeOut', const FadeParams(curve: Curves.easeOut));
  }

  static void register(String name, FadeParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static FadeParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
