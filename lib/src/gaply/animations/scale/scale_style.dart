import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_scale.dart';
import 'scale_presets.dart';

import 'scale_style_modifier.dart';

part 'scale_trigger.dart';

@immutable
class ScaleStyle extends GaplyAnimStyle
    with GaplyAnimMixin<ScaleStyle>, _ScaleStyleMixin, ScaleStyleModifier<ScaleStyle> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const ScaleStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    required this.begin,
    required this.end,
    required this.isScaled,
    this.alignment = Alignment.center,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeInOut,
         delay: delay ?? Duration.zero,
       );

  const ScaleStyle.none()
    : this(
        duration: Duration.zero,
        curve: Curves.linear,
        delay: Duration.zero,
        begin: 0.0,
        end: 1.0,
        isScaled: false,
      );

  static void register(String name, ScaleStyle style) => GaplyScalePreset.register(name, style);

  factory ScaleStyle.preset(String name, {Alignment? alignment, bool? isScaled, VoidCallback? onComplete}) {
    final style = GaplyScalePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown scale preset: "$name". '
        'Available presets: ${GaplyScalePreset.instance.allKeys.join(", ")}',
      );
    }

    return style.copyWith(alignment: alignment, isScaled: isScaled, onComplete: onComplete);
  }

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
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _ScaleStyleMixin {
  ScaleStyle get scaleStyle => this as ScaleStyle;

  ScaleStyle copyWithScale(ScaleStyle scale) {
    return scaleStyle.copyWith(
      duration: scale.duration,
      curve: scale.curve,
      delay: scale.delay,
      onComplete: scale.onComplete,
      begin: scale.begin,
      end: scale.end,
      alignment: scale.alignment,
      isScaled: scale.isScaled,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!scaleStyle.hasEffect) return child;

    return _GaplyScaleTrigger(style: scaleStyle, trigger: trigger ?? DateTime.now(), child: child);
  }
}
