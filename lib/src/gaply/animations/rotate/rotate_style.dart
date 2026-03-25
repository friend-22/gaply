import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'gaply_rotate.dart';
import 'rotate_presets.dart';

part 'rotate_trigger.dart';

@immutable
class RotateStyle extends GaplyAnimStyle with GaplyAnimMixin<RotateStyle> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isRotated;
  final bool useRadians;

  const RotateStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
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

  static void register(String name, RotateStyle style) => GaplyRotatePreset.register(name, style);

  factory RotateStyle.preset(String name, {Alignment? alignment, bool? isRotated, VoidCallback? onComplete}) {
    final style = GaplyRotatePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown rotate preset: "$name". '
        'Available presets: ${GaplyRotatePreset.instance.allKeys.join(", ")}',
      );
    }

    return style.copyWith(alignment: alignment, isRotated: isRotated, onComplete: onComplete);
  }

  const RotateStyle.rotate90({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
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
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
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
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
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
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isRotated = true,
    bool useRadians = false,
  }) : this(
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
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isRotated,
    bool? useRadians,
  }) {
    return RotateStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
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

    return RotateStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      begin: lerpDouble(begin, other.begin, t) ?? begin,
      end: lerpDouble(end, other.end, t) ?? end,
      alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
      isRotated: t < 0.5 ? isRotated : other.isRotated,
      useRadians: t < 0.5 ? useRadians : other.useRadians,
    );
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isRotated, useRadians];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!hasEffect) return child;

    return _GaplyRotateTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
