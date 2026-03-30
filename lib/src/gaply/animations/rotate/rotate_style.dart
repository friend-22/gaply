import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'gaply_rotate.dart';
import 'rotate_preset.dart';
import 'rotate_style_modifier.dart';

part 'rotate_trigger.dart';

@immutable
class RotateStyle extends GaplyAnimStyle<RotateStyle>
    with
        GaplyTweenMixin<RotateStyle>,
        GaplyAnimMixin<RotateStyle>,
        _RotateStyleMixin,
        RotateStyleModifier<RotateStyle> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isRotated;
  final bool useRadians;

  const RotateStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.begin,
    required this.end,
    required this.isRotated,
    this.alignment = Alignment.center,
    this.useRadians = false,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeInOut,
         delay: delay ?? Duration.zero,
       );

  const RotateStyle.none() : this(duration: Duration.zero, begin: 0.0, end: 1.0, isRotated: false);

  // static void add(Object key, RotateStyle style) => GaplyRotatePreset.add(key, style);
  // static void addSafe(Object key, RotateStyle style) => GaplyRotatePreset.addSafe(key, style);
  //
  // factory RotateStyle.preset(
  //   Object key, {
  //   GaplyProfiler? profiler,
  //   Alignment? alignment,
  //   bool? isRotated,
  //   VoidCallback? onComplete,
  // }) {
  //   final style = GaplyRotatePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyRotatePreset.error("RotateStyle", key));
  //   }
  //   return style.copyWith(
  //     profiler: profiler,
  //     alignment: alignment,
  //     isRotated: isRotated,
  //     onComplete: onComplete,
  //   );
  // }

  const RotateStyle.rotate90({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         begin: 0,
         end: 90,
         alignment: Alignment.center,
         isRotated: isRotated,
         useRadians: useRadians,
       );

  const RotateStyle.rotate180({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         begin: 0,
         end: 180,
         alignment: Alignment.center,
         isRotated: isRotated,
         useRadians: useRadians,
       );

  const RotateStyle.rotate270({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         begin: 0,
         end: 270,
         alignment: Alignment.center,
         isRotated: isRotated,
         useRadians: useRadians,
       );

  const RotateStyle.rotate360({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         begin: 0,
         end: 360,
         alignment: Alignment.center,
         isRotated: isRotated,
         useRadians: useRadians,
       );

  @override
  RotateStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isRotated,
    bool? useRadians,
  }) {
    return RotateStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alignment: alignment ?? this.alignment,
      isRotated: isRotated ?? this.isRotated,
      useRadians: useRadians ?? this.useRadians,
    );
  }

  @override
  RotateStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! RotateStyle) return this;

    return profiler.trace(() {
      return RotateStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        begin: lerpDouble(begin, other.begin, t) ?? begin,
        end: lerpDouble(end, other.end, t) ?? end,
        alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
        isRotated: t < 0.5 ? isRotated : other.isRotated,
        useRadians: t < 0.5 ? useRadians : other.useRadians,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isRotated, useRadians];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _RotateStyleMixin {
  RotateStyle get _self => this as RotateStyle;
  RotateStyle get rotateStyle => _self;

  RotateStyle copyWithRotate(RotateStyle rotate) {
    return _self.copyWith(
      profiler: rotate.profiler,
      duration: rotate.duration,
      curve: rotate.curve,
      delay: rotate.delay,
      onComplete: rotate.onComplete,
      progress: rotate.progress,
      begin: rotate.begin,
      end: rotate.end,
      alignment: rotate.alignment,
      isRotated: rotate.isRotated,
      useRadians: rotate.useRadians,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyRotateTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}
