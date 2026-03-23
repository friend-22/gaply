part of '../gaply_animation.dart';

@immutable
abstract class AnimationParams extends ParamsBase<AnimationParams> {
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final VoidCallback? onComplete;
  final VoidCallback? _internalComplete;

  const AnimationParams({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.onComplete,
    this.delay = Duration.zero,
    VoidCallback? internalComplete,
  }) : _internalComplete = internalComplete;

  AnimationParams withDelay(Duration delay);
  AnimationParams withDurationScale(double scale);

  Widget buildWidget({required Widget child, Object? trigger});

  @override
  bool get isEnabled => duration.inMilliseconds > 0;

  @override
  List<Object?> get props => [duration, curve, onComplete, _internalComplete, delay];
}

mixin AnimationParamsWithMixin<T extends AnimationParams> {
  T copyWith({Duration? duration, Duration? delay, VoidCallback? onComplete});

  T get _self => this as T;

  T withDelay(Duration delay) {
    return copyWith(delay: delay.isNegative ? Duration.zero : delay);
  }

  T withDurationScale(double scale) {
    if (scale <= 0 || !scale.isFinite) return _self;

    final double resolveMs = _self.duration.inMilliseconds * scale;
    final int finalMs = resolveMs.toInt().clamp(1, 86400000);

    return copyWith(duration: Duration(milliseconds: finalMs));
  }

  T _copyWithInternal(VoidCallback? callback) {
    print('Internal Callback 주입됨: $T'); // 이게 찍히는지 확인!
    return (this as dynamic).copyWithInternal(
          internalComplete: () {
            try {
              callback?.call();
            } catch (e) {
              debugPrint('콜백 실행 중 안전하게 에러 포착: $e');
            }
          },
        )
        as T;
  }
}

mixin DirectionAnimationParamsMixin {
  AxisDirection get direction;

  Axis get axis => axisDirectionToAxis(direction);
  bool get isReversed => axisDirectionIsReversed(direction);
  bool get isHorizontal => axis == Axis.horizontal;

  AxisDirection get reversedDirection => flipAxisDirection(direction);
}
