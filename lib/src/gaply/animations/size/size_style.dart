import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/utils/gaply_profiler.dart';
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
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
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

  // static void register(Object key, SizeStyle style) => GaplySizePreset.add(key, style);
  //
  // factory SizeStyle.preset(
  //   Object key, {
  //   GaplyProfiler? profiler,
  //   double? axisAlignment,
  //   bool? isExpanded,
  //   double? minFactor,
  //   VoidCallback? onComplete,
  // }) {
  //   final style = GaplySizePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplySizePreset.error("SizeStyle", key));
  //   }
  //
  //   return style.copyWith(
  //     profiler: profiler,
  //     axisAlignment: axisAlignment,
  //     isExpanded: isExpanded,
  //     minFactor: minFactor,
  //     onComplete: onComplete,
  //   );
  // }

  const SizeStyle.left({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
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
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Axis? axis,
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
  }) {
    return SizeStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      isExpanded: isExpanded ?? this.isExpanded,
      minFactor: minFactor ?? this.minFactor,
    );
  }

  @override
  SizeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SizeStyle) return this;

    return profiler.trace(() {
      return SizeStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        axis: t < 0.5 ? axis : other.axis,
        axisAlignment: lerpDouble(axisAlignment, other.axisAlignment, t) ?? axisAlignment,
        isExpanded: t < 0.5 ? isExpanded : other.isExpanded,
        minFactor: lerpDouble(minFactor, other.minFactor, t) ?? minFactor,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, axis, axisAlignment, isExpanded, minFactor];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || target < 1.0;

  double get target => isExpanded ? 1.0 : minFactor;
}

mixin _SizeStyleMixin {
  SizeStyle get _self => this as SizeStyle;
  SizeStyle get sizeStyle => _self;

  SizeStyle copyWithSize(SizeStyle size) {
    return _self.copyWith(
      profiler: size.profiler,
      duration: size.duration,
      curve: size.curve,
      delay: size.delay,
      onComplete: size.onComplete,
      progress: size.progress,
      axis: size.axis,
      axisAlignment: size.axisAlignment,
      isExpanded: size.isExpanded,
      minFactor: size.minFactor,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplySizeTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}
