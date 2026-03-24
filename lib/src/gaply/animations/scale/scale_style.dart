import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_scale.dart';
import 'scale_presets.dart';

part 'scale_trigger.dart';

@immutable
class ScaleStyle extends GaplyAnimStyle with GaplyAnimMixin<ScaleStyle> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const ScaleStyle({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.begin,
    required this.end,
    this.alignment = Alignment.center,
    required this.isScaled,
  });

  const ScaleStyle.none()
    : this(
        duration: Duration.zero,
        curve: Curves.linear,
        begin: 0.0,
        end: 1.0,
        alignment: Alignment.center,
        isScaled: false,
      );

  static void register(String name, ScaleStyle style) => GaplyScalePreset.register(name, style);

  factory ScaleStyle.preset(String name, {Alignment? alignment, bool? isScaled, VoidCallback? onComplete}) {
    final style = GaplyScalePreset.of(name);

    if (style == null) {
      throw ArgumentError('Unknown scale preset: "$name"');
    }

    return style.copyWith(alignment: alignment, isScaled: isScaled, onComplete: onComplete);
  }

  @override
  bool get isEnabled => isScaled && duration.inMilliseconds > 0;

  @override
  ScaleStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isScaled,
  }) {
    return ScaleStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alignment: alignment ?? this.alignment,
      isScaled: isScaled ?? this.isScaled,
    );
  }

  @override
  ScaleStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! ScaleStyle) return this;

    return ScaleStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      begin: lerpDouble(begin, other.begin, t) ?? begin,
      end: lerpDouble(end, other.end, t) ?? end,
      alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
      isScaled: t < 0.5 ? isScaled : other.isScaled,
    );
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isScaled];

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplyScaleTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
