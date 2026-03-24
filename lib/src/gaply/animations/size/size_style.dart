import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_size.dart';
import 'size_preset.dart';

part 'size_trigger.dart';

@immutable
class SizeStyle extends GaplyAnimStyle with GaplyAnimMixin<SizeStyle> {
  final Axis axis;
  final double axisAlignment;
  final bool isExpanded;

  const SizeStyle({
    super.duration = const Duration(milliseconds: 400),
    super.curve = Curves.easeOutCubic,
    super.delay = Duration.zero,
    super.onComplete,
    required this.axis,
    required this.isExpanded,
    this.axisAlignment = -1.0,
  });

  const SizeStyle.none()
    : this(duration: Duration.zero, curve: Curves.linear, axis: Axis.vertical, isExpanded: false);

  static void register(String name, SizeStyle style) => GaplySizePreset.register(name, style);

  factory SizeStyle.preset(String name, {double? axisAlignment, bool? isExpanded, VoidCallback? onComplete}) {
    final style = GaplySizePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown size preset: "$name". '
        'Available presets: ${GaplySizePreset.instance.allKeys.join(", ")}',
      );
    }

    return style.copyWith(axisAlignment: axisAlignment, isExpanded: isExpanded, onComplete: onComplete);
  }

  const SizeStyle.left({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
       );

  const SizeStyle.right({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
       );

  const SizeStyle.up({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
       );

  const SizeStyle.down({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
       );

  const SizeStyle.vertical({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
       );

  const SizeStyle.horizontal({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
    bool isExpanded = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
       );

  @override
  SizeStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    Axis? axis,
    double? axisAlignment,
    bool? isExpanded,
  }) {
    return SizeStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  SizeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SizeStyle) return this;

    return SizeStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      axis: t < 0.5 ? axis : other.axis,
      axisAlignment: lerpDouble(axisAlignment, other.axisAlignment, t) ?? axisAlignment,
      isExpanded: t < 0.5 ? isExpanded : other.isExpanded,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, axisAlignment, isExpanded];

  @override
  bool get isEnabled => duration.inMilliseconds > 0 || !isExpanded;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplySizeTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
