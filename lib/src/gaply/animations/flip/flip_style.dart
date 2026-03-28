import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'gaply_flip.dart';
import 'flip_presets.dart';
import 'flip_style_modifier.dart';

part 'flip_trigger.dart';

/// A configuration style for 3D flip animations.
///
/// [FlipStyle] defines the physical properties of a flip, such as the axis
/// of rotation, the total angle, and which side is currently visible.
///
/// ### Example Usage:
///
/// ```dart
/// final flipStyle = FlipStyle(
///   axis: Axis.horizontal,
///   isFlipped: _isFlipped,
///   duration: Duration(milliseconds: 600),
///   backWidget: Center(child: Text('Back Side')),
/// );
/// ```
@immutable
class FlipStyle extends GaplyAnimStyle<FlipStyle>
    with
        GaplyTweenMixin<FlipStyle>,
        GaplyAnimMixin<FlipStyle>,
        _GaplyFlipMixin,
        FlipStyleModifier<FlipStyle> {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;
  final Widget? backWidget;

  const FlipStyle({
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

  const FlipStyle.none() : this(duration: Duration.zero, axis: Axis.horizontal, isFlipped: false);

  /// Creates a [FlipStyle] from a pre-registered preset name.
  ///
  /// Available default presets: 'vertical', 'horizontal'.
  /// Throws [ArgumentError] if the [name] is not registered.
  static void register(Object name, FlipStyle style) => GaplyFlipPreset.register(name, style);

  factory FlipStyle.preset(
    Object name, {
    GaplyProfiler? profiler,
    Widget? backWidget,
    bool? isFlipped,
    VoidCallback? onComplete,
  }) {
    final style = GaplyFlipPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyFlipPreset.instance.errorMessage("FlipStyle", name));
    }
    return style.copyWith(
      profiler: profiler,
      backWidget: backWidget,
      isFlipped: isFlipped,
      onComplete: onComplete,
    );
  }

  const FlipStyle.vertical(
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

  const FlipStyle.horizontal(
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
  FlipStyle copyWith({
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
    return FlipStyle(
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
  FlipStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! FlipStyle) return this;

    return profiler.trace(() {
      return FlipStyle(
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
  FlipStyle get _self => this as FlipStyle;
  FlipStyle get flipStyle => _self;

  FlipStyle copyWithFlip(FlipStyle flip) {
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
