import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_flip.dart';
import 'flip_presets.dart';

part 'flip_trigger.dart';

/// A configuration style for 3D flip animations.
///
/// [FlipStyle] defines the physical properties of a flip, such as the axis
/// of rotation, the total angle, and which side is currently visible.
///
/// ### Example Usage:
///
/// ```dart
/// final flipStyle = FlipStyle(
///   axis: Axis.horizontal,
///   isFlipped: _isFlipped,
///   duration: Duration(milliseconds: 600),
///   backWidget: Center(child: Text('Back Side')),
/// );
/// ```
@immutable
class FlipStyle extends GaplyAnimStyle with GaplyAnimMixin<FlipStyle> {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;
  final Widget? backWidget;

  const FlipStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    required this.axis,
    required this.isFlipped,
    this.angleRange = math.pi,
    this.backWidget,
  }) : assert(angleRange > 0 && angleRange <= 2 * math.pi, 'angleRange must be in the range of 0 to 2π.'),
       super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.fastOutSlowIn,
         delay: delay ?? Duration.zero,
       );

  const FlipStyle.none() : this(duration: Duration.zero, axis: Axis.horizontal, isFlipped: false);

  /// Creates a [FlipStyle] from a pre-registered preset name.
  ///
  /// Available default presets: 'vertical', 'horizontal'.
  /// Throws [ArgumentError] if the [name] is not registered.
  static void register(String name, FlipStyle style) => GaplyFlipPreset.register(name, style);

  factory FlipStyle.preset(String name, {Widget? backWidget, bool? isFlipped, VoidCallback? onComplete}) {
    final style = GaplyFlipPreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown flip preset: "$name". '
        'Available presets: ${GaplyFlipPreset.instance.allKeys.join(", ")}',
      );
    }
    return style.copyWith(isFlipped: isFlipped, backWidget: backWidget, onComplete: onComplete);
  }

  const FlipStyle.vertical(
    Widget backWidget, {
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isFlipped = true,
  }) : this(
         backWidget: backWidget,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         isFlipped: isFlipped,
       );

  const FlipStyle.horizontal(
    Widget backWidget, {
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isFlipped = true,
  }) : this(
         backWidget: backWidget,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         isFlipped: isFlipped,
       );

  @override
  FlipStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    Axis? axis,
    double? angleRange,
    bool? isFlipped,
    Widget? backWidget,
  }) {
    return FlipStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      axis: axis ?? this.axis,
      angleRange: angleRange ?? this.angleRange,
      isFlipped: isFlipped ?? this.isFlipped,
      backWidget: backWidget ?? this.backWidget,
    );
  }

  @override
  FlipStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! FlipStyle) return this;

    return FlipStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      axis: t < 0.5 ? axis : other.axis,
      angleRange: lerpDouble(angleRange, other.angleRange, t) ?? angleRange,
      isFlipped: t < 0.5 ? isFlipped : other.isFlipped,
      backWidget: t < 0.5 ? backWidget : other.backWidget,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, angleRange, isFlipped, backWidget];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!hasEffect) return child;

    return _GaplyFlipTrigger(
      front: child,
      back: backWidget ?? child,
      trigger: trigger ?? DateTime.now(),
      style: this,
    );
  }
}
