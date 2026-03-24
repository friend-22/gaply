import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class GaplyStyle<T> extends Equatable {
  const GaplyStyle();

  bool get isEnabled;

  T lerp(T? other, double t);

  T copyWith();

  @override
  List<Object?> get props;
}

@immutable
abstract class GaplyAnimStyle extends GaplyStyle<GaplyAnimStyle> {
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final VoidCallback? onComplete;

  const GaplyAnimStyle({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    this.onComplete,
    this.delay = Duration.zero,
  });

  GaplyAnimStyle withDelay(Duration delay);
  GaplyAnimStyle withDurationScale(double scale);
  Widget buildWidget({required Widget child, Object? trigger});

  @override
  bool get isEnabled => duration.inMilliseconds > 0;

  @override
  List<Object?> get props => [duration, curve, onComplete, delay];
}

mixin GaplyAnimMixin<T extends GaplyAnimStyle> {
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
}
