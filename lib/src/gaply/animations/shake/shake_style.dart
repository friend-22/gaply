import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'shake_presets.dart';
import 'gaply_shake.dart';
import 'shake_style_modifier.dart';

part 'shake_trigger.dart';

/// A configuration style for shake animations.
///
/// [ShakeStyle] controls the amplitude and frequency of a shake effect.
/// The animation produces a sinusoidal motion that dampens over time.
///
/// ### Properties
/// - **distance**: Maximum translation distance in logical pixels
/// - **count**: Number of oscillations (can be fractional)
/// - **isVertical**: Direction of shake (true = up/down, false = left/right)
/// - **useHaptic**: Whether to trigger haptic feedback
/// - **useRepaintBoundary**: Whether to optimize repainting
///
/// ### Examples
///
/// **Basic shake:**
/// ```dart
/// ShakeStyle(
///   distance: 8.0,
///   count: 4.0,
///   duration: Duration(milliseconds: 500),
/// )
/// ```
///
/// **Vertical bounce:**
/// ```dart
/// ShakeStyle(
///   isVertical: true,
///   distance: 10.0,
///   count: 3.0,
/// )
/// ```
@immutable
class ShakeStyle extends GaplyAnimStyle
    with GaplyAnimMixin<ShakeStyle>, _ShakeStyleMixin, ShakeStyleModifier<ShakeStyle> {
  /// Maximum translation distance in logical pixels
  final double distance;

  /// Number of oscillations (can be fractional, e.g., 2.5)
  final double count;

  /// Whether to trigger haptic feedback during shake
  final bool useHaptic;

  /// Whether to use RepaintBoundary for optimization
  final bool useRepaintBoundary;

  /// Whether shake is vertical (true) or horizontal (false)
  final bool isVertical;

  const ShakeStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
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

  /// Creates a [ShakeStyle] from a pre-defined preset name.
  ///
  /// Available presets: 'mild', 'normal', 'severe', 'alert', 'nod', 'celebrate'
  ///
  /// Throws [ArgumentError] if the [name] is not registered.
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

  /// Returns a new [ShakeStyle] with intensity multiplied by [intensity].
  ///
  /// Both distance and count are scaled proportionally.
  ShakeStyle withIntensityScale(double intensity) {
    assert(intensity >= 0, 'intensity must be non-negative');
    return copyWith(distance: distance * intensity, count: (count * intensity).toDouble());
  }

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
  bool get hasEffect => duration.inMilliseconds > 0 && distance > 0 && count > 0;
}

mixin _ShakeStyleMixin {
  ShakeStyle get shakeStyle => this as ShakeStyle;

  ShakeStyle copyWithShake(ShakeStyle shake) {
    return shakeStyle.copyWith(
      duration: shake.duration,
      curve: shake.curve,
      delay: shake.delay,
      onComplete: shake.onComplete,
      distance: shake.distance,
      count: shake.count,
      useHaptic: shake.useHaptic,
      useRepaintBoundary: shake.useRepaintBoundary,
      isVertical: shake.isVertical,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!shakeStyle.hasEffect) return child;

    return _GaplyShakeTrigger(style: shakeStyle, trigger: trigger ?? DateTime.now(), child: child);
  }
}
