import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'shake_presets.dart';
import 'gaply_shake.dart';

part 'shake_trigger.dart';

@immutable
class ShakeStyle extends GaplyAnimStyle with GaplyAnimMixin<ShakeStyle> {
  final double distance;
  final double count;
  final bool useHaptic;
  final bool useRepaintBoundary;
  final bool isVertical;

  const ShakeStyle({
    super.duration = const Duration(milliseconds: 500),
    super.curve = Curves.linear,
    super.delay = Duration.zero,
    super.onComplete,
    this.distance = 8.0,
    this.count = 4.0,
    this.useHaptic = true,
    this.useRepaintBoundary = true,
    this.isVertical = false,
  });

  const ShakeStyle.none() : this(duration: Duration.zero, curve: Curves.linear, distance: 0.0, count: 0.0);

  static void register(String name, ShakeStyle style) => GaplyShakePreset.register(name, style);

  factory ShakeStyle.preset(
    String name, {
    double? distance,
    double? count,
    bool? isVertical,
    VoidCallback? onComplete,
  }) {
    final style = GaplyShakePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown shake preset: "$name". '
        'Available presets: ${GaplyShakePreset.instance.allKeys.join(", ")}',
      );
    }

    return style.copyWith(distance: distance, count: count, isVertical: isVertical, onComplete: onComplete);
  }

  ShakeStyle withIntensity(double intensity) {
    return copyWith(distance: distance * intensity, count: (count * intensity).toDouble());
  }

  @override
  bool get isEnabled => duration.inMilliseconds > 0 && distance > 0;

  @override
  ShakeStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    double? distance,
    double? count,
    bool? useHaptic,
    bool? useRepaintBoundary,
    bool? isVertical,
  }) {
    return ShakeStyle(
      distance: distance ?? this.distance,
      count: count ?? this.count,
      duration: duration ?? this.duration,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      useHaptic: useHaptic ?? this.useHaptic,
      useRepaintBoundary: useRepaintBoundary ?? this.useRepaintBoundary,
      isVertical: isVertical ?? this.isVertical,
    );
  }

  @override
  ShakeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! ShakeStyle) return this;
    return ShakeStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      distance: lerpDouble(distance, other.distance, t) ?? distance,
      count: lerpDouble(count, other.count, t) ?? count,
      useHaptic: t < 0.5 ? useHaptic : other.useHaptic,
      useRepaintBoundary: t < 0.5 ? useRepaintBoundary : other.useRepaintBoundary,
      isVertical: t < 0.5 ? isVertical : other.isVertical,
    );
  }

  @override
  List<Object?> get props => [...super.props, distance, count, useHaptic, useRepaintBoundary, isVertical];

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplyShakeTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
