import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/utils/gaply_perf.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'skew_presets.dart';
import 'gaply_skew.dart';
import 'skew_style_modifier.dart';

part 'skew_trigger.dart';

@immutable
class SkewStyle extends GaplyAnimStyle<SkewStyle>
    with
        GaplyTweenMixin<SkewStyle>,
        GaplyAnimMixin<SkewStyle>,
        _SkewStyleMixin,
        SkewStyleModifier<SkewStyle> {
  final Offset skew;
  final bool isSkewed;

  const SkewStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.skew,
    required this.isSkewed,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const SkewStyle.none() : this(duration: Duration.zero, skew: Offset.zero, isSkewed: false);

  static void register(String name, SkewStyle style) => GaplySkewPreset.register(name, style);

  factory SkewStyle.preset(String name, {GaplyProfiler? profiler, bool? isSkewed, VoidCallback? onComplete}) {
    final style = GaplySkewPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplySkewPreset.instance.errorMessage("SkewStyle", name));
    }
    return style.copyWith(profiler: profiler, isSkewed: isSkewed, onComplete: onComplete);
  }

  SkewStyle.horizontal(
    double amount, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(amount, 0),
         isSkewed: isSkewed,
       );

  SkewStyle.vertical(
    double amount, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(0, amount),
         isSkewed: isSkewed,
       );

  @override
  SkewStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Offset? skew,
    bool? isSkewed,
  }) {
    return SkewStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      skew: skew ?? this.skew,
      isSkewed: isSkewed ?? this.isSkewed,
    );
  }

  @override
  SkewStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SkewStyle) return this;

    return profiler.trace(() {
      return SkewStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        skew: Offset.lerp(skew, other.skew, t)!,
        isSkewed: t < 0.5 ? isSkewed : other.isSkewed,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, skew, isSkewed];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || isSkewed;
}

mixin _SkewStyleMixin {
  SkewStyle get _self => this as SkewStyle;
  SkewStyle get skewStyle => _self;

  SkewStyle copyWithSkew(SkewStyle skew) {
    return _self.copyWith(
      profiler: skew.profiler,
      duration: skew.duration,
      curve: skew.curve,
      delay: skew.delay,
      onComplete: skew.onComplete,
      progress: skew.progress,
      skew: skew.skew,
      isSkewed: skew.isSkewed,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplySkewTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}
