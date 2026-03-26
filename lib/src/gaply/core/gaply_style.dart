import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class GaplyToken<T> extends Equatable {
  final T value;

  const GaplyToken(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is GaplyToken<T>) return value == other.value;
    if (other is T) return value == other;
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value.toString();
}

@immutable
abstract class GaplyStyle<T> extends Equatable {
  const GaplyStyle();

  bool get hasEffect;

  T lerp(T? other, double t);

  T copyWith();

  @override
  List<Object?> get props;
}

@immutable
abstract class GaplyTweenStyle<T extends GaplyTweenStyle<T>> extends GaplyStyle<T> {
  final Duration duration;
  final Curve curve;
  final VoidCallback? onComplete;

  const GaplyTweenStyle({required this.duration, required this.curve, this.onComplete});

  @override
  T copyWith({Duration? duration, Curve? curve, VoidCallback? onComplete});

  GaplyTweenStyle withDurationScale(double scale);

  @override
  List<Object?> get props => [duration, curve, onComplete];
}

mixin GaplyTweenMixin<T extends GaplyTweenStyle<T>> {
  T get _self => this as T;

  T withDurationScale(double scale) {
    if (scale <= 0 || !scale.isFinite) return _self;

    final double resolveMs = _self.duration.inMilliseconds * scale;
    final int finalMs = resolveMs.toInt().clamp(1, 86400000);

    return _self.copyWith(duration: Duration(milliseconds: finalMs));
  }
}

@immutable
abstract class GaplyAnimStyle<T extends GaplyAnimStyle<T>> extends GaplyTweenStyle<T> {
  final Duration delay;

  const GaplyAnimStyle({
    required super.duration,
    required super.curve,
    super.onComplete,
    this.delay = Duration.zero,
  });

  @override
  T copyWith({Duration? duration, Curve? curve, Duration? delay, VoidCallback? onComplete});

  GaplyAnimStyle withDelay(Duration delay);

  Widget buildWidget({required Widget child, Object? trigger});

  @override
  List<Object?> get props => [...super.props, delay];
}

mixin GaplyAnimMixin<T extends GaplyAnimStyle<T>> on GaplyTweenMixin<T> {
  T withDelay(Duration delay) {
    return _self.copyWith(delay: delay.isNegative ? Duration.zero : delay);
  }
}

@immutable
abstract class GaplyThemeData<T extends GaplyThemeData<T>> extends GaplyTweenStyle<T> {
  final Brightness brightness;

  const GaplyThemeData({
    required this.brightness,
    required super.duration,
    required super.curve,
    super.onComplete,
  });

  @override
  T copyWith({Brightness? brightness, Duration? duration, Curve? curve, VoidCallback? onComplete});

  @override
  List<Object?> get props => [...super.props, brightness];
}
