import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'flip_widget.dart';
import 'flip_style_modifier.dart';

part 'flip_trigger.dart';
part 'flip_style.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyFlipStyle extends GaplyAnimStyle<GaplyFlipStyle>
    with
        GaplyTweenMixin<GaplyFlipStyle>,
        GaplyAnimMixin<GaplyFlipStyle>,
        _GaplyFlipMixin,
        FlipStyleModifier<GaplyFlipStyle> {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;
  final Widget? backWidget;

  const GaplyFlipStyle({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
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

  const GaplyFlipStyle.none() : this(duration: Duration.zero, axis: Axis.horizontal, isFlipped: false);

  static GaplyFlipPreset preset = GaplyFlipPreset._i;

  factory GaplyFlipStyle.fromPreset(
    Object key, {
    GaplyProfiler? profiler,
    Widget? backWidget,
    bool? isFlipped,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(
      profiler: profiler,
      backWidget: backWidget,
      isFlipped: isFlipped,
      onComplete: onComplete,
    );
  }

  const GaplyFlipStyle.vertical(
    Widget backWidget, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isFlipped = true,
  }) : this(
         profiler: profiler,
         backWidget: backWidget,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         isFlipped: isFlipped,
       );

  const GaplyFlipStyle.horizontal(
    Widget backWidget, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isFlipped = true,
  }) : this(
         profiler: profiler,
         backWidget: backWidget,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         isFlipped: isFlipped,
       );

  @override
  GaplyFlipStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Axis? axis,
    double? angleRange,
    bool? isFlipped,
    Widget? backWidget,
  }) {
    return GaplyFlipStyle(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      axis: axis ?? this.axis,
      angleRange: angleRange ?? this.angleRange,
      isFlipped: isFlipped ?? this.isFlipped,
      backWidget: backWidget ?? this.backWidget,
    );
  }

  @override
  GaplyFlipStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyFlipStyle) return this;

    return profiler.trace(() {
      return GaplyFlipStyle(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        axis: t < 0.5 ? axis : other.axis,
        angleRange: lerpDouble(angleRange, other.angleRange, t) ?? angleRange,
        isFlipped: t < 0.5 ? isFlipped : other.isFlipped,
        backWidget: t < 0.5 ? backWidget : other.backWidget,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, axis, angleRange, isFlipped, backWidget];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _GaplyFlipMixin {
  GaplyFlipStyle get _self => this as GaplyFlipStyle;
  GaplyFlipStyle get flipStyle => _self;

  GaplyFlipStyle copyWithFlip(GaplyFlipStyle flip) {
    return _self.copyWith(
      profiler: flip.profiler,
      duration: flip.duration,
      curve: flip.curve,
      delay: flip.delay,
      onComplete: flip.onComplete,
      progress: flip.progress,
      axis: flip.axis,
      angleRange: flip.angleRange,
      isFlipped: flip.isFlipped,
      backWidget: flip.backWidget,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyFlipTrigger(
      front: child,
      back: _self.backWidget ?? child,
      trigger: trigger ?? DateTime.now(),
      style: _self,
    );
  }
}

void _initPresets(GaplyFlipPreset preset) {}
