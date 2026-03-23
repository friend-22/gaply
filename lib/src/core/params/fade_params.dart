import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/fade_widget.dart';
import '../base/animation_params.dart';

@immutable
class FadeParams extends AnimationParams {
  final bool visible;

  const FadeParams({super.duration, super.curve, super.onComplete, required this.visible});

  const FadeParams.none() : this(duration: Duration.zero, curve: Curves.linear, visible: false);

  factory FadeParams.preset(String name, {bool? visible}) {
    final params = GaplyFadePreset.of(name);

    if (params == null) {
      throw ArgumentError('Unknown fade preset: "$name"');
    }

    return visible != null ? params.copyWith(visible: visible) : params;
  }

  FadeParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
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
    return FadeTrigger(params: this, trigger: DateTime.now(), child: child);
  }
}

extension FadeParamsX on FadeParams {}

extension FadeParamsExtension on Widget {
  Widget withFade(FadeParams params) => FadeTrigger(params: params, trigger: DateTime.now(), child: this);
}

class GaplyFadePreset with GaplyPreset<FadeParams> {
  static final GaplyFadePreset instance = GaplyFadePreset._internal();
  GaplyFadePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'fadeIn',
      const FadeParams(duration: Duration(milliseconds: 500), curve: Curves.easeInOut, visible: true),
    );
    add(
      'fadeOut',
      const FadeParams(duration: Duration(milliseconds: 500), curve: Curves.easeOut, visible: false),
    );
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
