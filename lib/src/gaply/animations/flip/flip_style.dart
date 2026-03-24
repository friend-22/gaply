import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_flip.dart';
import 'flip_presets.dart';

part 'flip_trigger.dart';

@immutable
class FlipStyle extends GaplyAnimStyle with GaplyAnimMixin<FlipStyle> {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;
  final Widget? backWidget;

  const FlipStyle({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.axis,
    this.angleRange = math.pi,
    required this.isFlipped,
    this.backWidget,
  }) : assert(angleRange > 0 && angleRange <= 2 * math.pi, 'angleRange은 0~2π 범위여야 합니다');

  const FlipStyle.none() : this(duration: Duration.zero, axis: Axis.horizontal, isFlipped: false);

  static void register(String name, FlipStyle style) => GaplyFlipPreset.register(name, style);

  factory FlipStyle.preset(String name, {Widget? backWidget, bool? isFlipped, VoidCallback? onComplete}) {
    final style = GaplyFlipPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown flip preset: "$name"');
    }
    return style.copyWith(isFlipped: isFlipped, backWidget: backWidget, onComplete: onComplete);
  }

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
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplyFlipTrigger(
      front: child,
      back: backWidget ?? child,
      trigger: trigger ?? DateTime.now(),
      style: this,
    );
  }
}
