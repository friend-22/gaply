import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'gaply_defines.dart';
import 'package:gaply/src/hub/profiler/gaply_profiler.dart';

// ---------------------------------------------------------------------------
// SECTION: Resolver & Policy
// ---------------------------------------------------------------------------

class GaplyResolver {
  static Object? resolve(Object? key, GaplyResolvePolicy policy) {
    if (key == null) return null;
    if (key is String) {
      final trimmed = key.trim();
      return trimmed.isEmpty
          ? null
          : (policy == GaplyResolvePolicy.insensitive ? trimmed.toLowerCase() : trimmed);
    }
    if (key is Enum) {
      final name = (policy == GaplyResolvePolicy.strict) ? "${key.runtimeType}.${key.name}" : key.name;
      return policy == GaplyResolvePolicy.insensitive ? name.toLowerCase() : name;
    }
    if (key is Record) return key.toString();
    return key;
  }
}

// ---------------------------------------------------------------------------
// SECTION: Identities
// ---------------------------------------------------------------------------
@immutable
abstract class GaplyIdentity<T> extends Equatable {
  final T value;

  const GaplyIdentity(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is GaplyIdentity<T>) return value == other.value;
    return value == other;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value.toString();
}

@immutable
abstract class GaplyNumericIdentity<Self extends GaplyNumericIdentity<Self>> extends GaplyIdentity<double> {
  const GaplyNumericIdentity(super.value);

  double _clamp(double val) => val.clamp(0.0, 1.0);

  Self create(double val);

  Self operator +(num other) => create(_clamp(value + other.toDouble()));
  Self operator -(num other) => create(_clamp(value - other.toDouble()));
  Self operator *(num other) => create(_clamp(value * other.toDouble()));
  Self operator /(num other) => create(_clamp(value / other.toDouble()));
}

// ---------------------------------------------------------------------------
// SECTION: Styles & Animations
// ---------------------------------------------------------------------------
@immutable
abstract class GaplyStyle<T> extends Equatable {
  final GaplyProfiler profiler;

  const GaplyStyle({GaplyProfiler? profiler}) : profiler = profiler ?? const GaplyProfiler.none();

  bool get hasEffect;

  T lerp(T? other, double t);

  T copyWith({GaplyProfiler? profiler});

  @override
  List<Object?> get props;
}

@immutable
abstract class GaplyTweenStyle<T extends GaplyTweenStyle<T>> extends GaplyStyle<T> {
  final Duration duration;
  final Curve curve;
  final VoidCallback? onComplete;
  final double progress;

  const GaplyTweenStyle({
    super.profiler,
    required this.duration,
    required this.curve,
    this.onComplete,
    this.progress = 1.0,
  });

  @override
  T copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
  });

  GaplyTweenStyle withDurationScale(double scale);

  @override
  List<Object?> get props => [duration, curve, onComplete, progress];
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
    super.profiler,
    required super.duration,
    required super.curve,
    super.onComplete,
    super.progress,
    this.delay = Duration.zero,
  });

  @override
  T copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
  });

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

// ---------------------------------------------------------------------------
// SECTION: ThemeData
// ---------------------------------------------------------------------------
@immutable
abstract class GaplyThemeData<T extends GaplyThemeData<T>> extends GaplyTweenStyle<T> {
  final Brightness brightness;

  const GaplyThemeData({
    super.profiler,
    required this.brightness,
    required super.duration,
    required super.curve,
    super.onComplete,
    super.progress,
  });

  @override
  T copyWith({
    GaplyProfiler? profiler,
    Brightness? brightness,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? progress,
  });

  @override
  List<Object?> get props => [...super.props, brightness];
}
