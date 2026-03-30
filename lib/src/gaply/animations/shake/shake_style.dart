import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'shake_preset.dart';
import 'gaply_shake.dart';
import 'shake_style_modifier.dart';

part 'shake_trigger.dart';

@immutable
class ShakeStyle extends GaplyAnimStyle<ShakeStyle>
    with
        GaplyTweenMixin<ShakeStyle>,
        GaplyAnimMixin<ShakeStyle>,
        _ShakeStyleMixin,
        ShakeStyleModifier<ShakeStyle> {
  final double distance;
  final double count;
  final bool useHaptic;
  final bool useRepaintBoundary;
  final bool isVertical;

  const ShakeStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    this.distance = 8.0,
    this.count = 4.0,
    this.useHaptic = true,
    this.useRepaintBoundary = true,
    this.isVertical = false,
  }) : assert(distance >= 0, 'distance must be non-negative'),
       assert(count > 0, 'count must be positive'),
       super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.linear,
         delay: delay ?? Duration.zero,
       );

  const ShakeStyle.none() : this(duration: Duration.zero, distance: 0.0, count: 0.0);

  // static void add(Object key, ShakeStyle style) => GaplyShakePreset.add(key, style);
  // static void addSafe(Object key, ShakeStyle style) => GaplyShakePreset.addSafe(key, style);
  //
  // factory ShakeStyle.preset(
  //   Object key, {
  //   GaplyProfiler? profiler,
  //   double? distance,
  //   double? count,
  //   bool? isVertical,
  //   VoidCallback? onComplete,
  // }) {
  //   final style = GaplyShakePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyShakePreset.error("ShakeStyle", key));
  //   }
  //   return style.copyWith(
  //     profiler: profiler,
  //
  //     distance: distance,
  //     count: count,
  //     isVertical: isVertical,
  //     onComplete: onComplete,
  //   );
  // }

  /// Returns a new [ShakeStyle] with intensity multiplied by [intensity].
  ///
  /// Both distance and count are scaled proportionally.
  ShakeStyle withIntensityScale(double intensity, {GaplyProfiler? profiler}) {
    assert(intensity >= 0, 'intensity must be non-negative');
    return copyWith(
      profiler: profiler,
      distance: distance * intensity,
      count: (count * intensity).toDouble(),
    );
  }

  @override
  ShakeStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    double? distance,
    double? count,
    bool? useHaptic,
    bool? useRepaintBoundary,
    bool? isVertical,
  }) {
    return ShakeStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      distance: distance ?? this.distance,
      count: count ?? this.count,
      useHaptic: useHaptic ?? this.useHaptic,
      useRepaintBoundary: useRepaintBoundary ?? this.useRepaintBoundary,
      isVertical: isVertical ?? this.isVertical,
    );
  }

  @override
  ShakeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! ShakeStyle) return this;

    return profiler.trace(() {
      return ShakeStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        distance: lerpDouble(distance, other.distance, t) ?? distance,
        count: lerpDouble(count, other.count, t) ?? count,
        useHaptic: t < 0.5 ? useHaptic : other.useHaptic,
        useRepaintBoundary: t < 0.5 ? useRepaintBoundary : other.useRepaintBoundary,
        isVertical: t < 0.5 ? isVertical : other.isVertical,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, distance, count, useHaptic, useRepaintBoundary, isVertical];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 && distance > 0 && count > 0;
}

mixin _ShakeStyleMixin {
  ShakeStyle get _self => this as ShakeStyle;
  ShakeStyle get shakeStyle => _self;

  ShakeStyle copyWithShake(ShakeStyle shake) {
    return _self.copyWith(
      profiler: shake.profiler,
      duration: shake.duration,
      curve: shake.curve,
      delay: shake.delay,
      onComplete: shake.onComplete,
      progress: shake.progress,
      distance: shake.distance,
      count: shake.count,
      useHaptic: shake.useHaptic,
      useRepaintBoundary: shake.useRepaintBoundary,
      isVertical: shake.isVertical,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyShakeTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}
