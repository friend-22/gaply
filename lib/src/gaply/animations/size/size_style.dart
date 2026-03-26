import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_size.dart';
import 'size_preset.dart';
import 'size_style_modifier.dart';

part 'size_trigger.dart';

@immutable
class SizeStyle extends GaplyAnimStyle<SizeStyle>
    with
        GaplyTweenMixin<SizeStyle>,
        GaplyAnimMixin<SizeStyle>,
        _SizeStyleMixin,
        SizeStyleModifier<SizeStyle> {
  final Axis axis;
  final double axisAlignment;
  final bool isExpanded;
  final double minFactor;

  const SizeStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    required this.axis,
    required this.isExpanded,
    this.minFactor = 0.0,
    this.axisAlignment = -1.0,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const SizeStyle.none() : this(duration: Duration.zero, axis: Axis.vertical, isExpanded: false);

  static void register(String name, SizeStyle style) => GaplySizePreset.register(name, style);

  factory SizeStyle.preset(
    String name, {
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
    VoidCallback? onComplete,
  }) {
    final style = GaplySizePreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplySizePreset.instance.errorMessage("SizeStyle", name));
    }

    return style.copyWith(
      axisAlignment: axisAlignment,
      isExpanded: isExpanded,
      minFactor: minFactor,
      onComplete: onComplete,
    );
  }

  const SizeStyle.left({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const SizeStyle.right({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const SizeStyle.up({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const SizeStyle.down({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const SizeStyle.vertical({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const SizeStyle.horizontal({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  @override
  SizeStyle copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    Axis? axis,
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
  }) {
    return SizeStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      isExpanded: isExpanded ?? this.isExpanded,
      minFactor: minFactor ?? this.minFactor,
    );
  }

  @override
  SizeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SizeStyle) return this;

    return SizeStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      delay: t < 0.5 ? delay : other.delay,
      onComplete: other.onComplete,
      axis: t < 0.5 ? axis : other.axis,
      axisAlignment: lerpDouble(axisAlignment, other.axisAlignment, t) ?? axisAlignment,
      isExpanded: t < 0.5 ? isExpanded : other.isExpanded,
      minFactor: lerpDouble(minFactor, other.minFactor, t) ?? minFactor,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, axisAlignment, isExpanded, minFactor];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || target < 1.0;

  double get target => isExpanded ? 1.0 : minFactor;
}

mixin _SizeStyleMixin {
  SizeStyle get sizeStyle => this as SizeStyle;

  SizeStyle copyWithSize(SizeStyle size) {
    return sizeStyle.copyWith(
      duration: size.duration,
      curve: size.curve,
      delay: size.delay,
      onComplete: size.onComplete,
      axis: size.axis,
      axisAlignment: size.axisAlignment,
      isExpanded: size.isExpanded,
      minFactor: size.minFactor,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!sizeStyle.hasEffect) return child;

    return _GaplySizeTrigger(style: sizeStyle, trigger: trigger ?? DateTime.now(), child: child);
  }
}
