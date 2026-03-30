import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_scale.dart';
import 'scale_preset.dart';
import 'scale_style_modifier.dart';

part 'scale_trigger.dart';

@immutable
class ScaleStyle extends GaplyAnimStyle<ScaleStyle>
    with
        GaplyTweenMixin<ScaleStyle>,
        GaplyAnimMixin<ScaleStyle>,
        _ScaleStyleMixin,
        ScaleStyleModifier<ScaleStyle> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const ScaleStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
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

  // static void add(Object key, ScaleStyle style) => GaplyScalePreset.add(key, style);
  // static void addSafe(Object key, ScaleStyle style) => GaplyScalePreset.addSafe(key, style);
  //
  // factory ScaleStyle.preset(
  //   Object key, {
  //   GaplyProfiler? profiler,
  //   Alignment? alignment,
  //   bool? isScaled,
  //   VoidCallback? onComplete,
  // }) {
  //   final style = GaplyScalePreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyScalePreset.error("ScaleStyle", key));
  //   }
  //   return style.copyWith(
  //     profiler: profiler,
  //     alignment: alignment,
  //     isScaled: isScaled,
  //     onComplete: onComplete,
  //   );
  // }

  @override
  ScaleStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isScaled,
  }) {
    return ScaleStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alignment: alignment ?? this.alignment,
      isScaled: isScaled ?? this.isScaled,
    );
  }

  @override
  ScaleStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! ScaleStyle) return this;

    return profiler.trace(() {
      return ScaleStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        begin: lerpDouble(begin, other.begin, t) ?? begin,
        end: lerpDouble(end, other.end, t) ?? end,
        alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
        isScaled: t < 0.5 ? isScaled : other.isScaled,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isScaled];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _ScaleStyleMixin {
  ScaleStyle get _self => this as ScaleStyle;
  ScaleStyle get scaleStyle => _self;

  ScaleStyle copyWithScale(ScaleStyle scale) {
    return _self.copyWith(
      profiler: scale.profiler,
      duration: scale.duration,
      curve: scale.curve,
      delay: scale.delay,
      onComplete: scale.onComplete,
      progress: scale.progress,
      begin: scale.begin,
      end: scale.end,
      alignment: scale.alignment,
      isScaled: scale.isScaled,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyScaleTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}
