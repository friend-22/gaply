import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'rotate_widget.dart';
import 'gaply_rotate_modifier.dart';

part 'rotate_trigger.dart';
part 'gaply_rotate.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyRotate extends GaplyAnimStyle<GaplyRotate>
    with
        GaplyTweenMixin<GaplyRotate>,
        GaplyAnimMixin<GaplyRotate>,
        _RotateStyleMixin,
        GaplyRotateModifier<GaplyRotate> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isRotated;
  final bool useRadians;

  const GaplyRotate({
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

  const GaplyRotate.none() : this(duration: Duration.zero, begin: 0.0, end: 1.0, isRotated: false);

  static GaplyRotatePreset preset = GaplyRotatePreset._i;

  factory GaplyRotate.of(
    Object key, {
    GaplyProfiler? profiler,
    Alignment? alignment,
    bool? isRotated,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(
      profiler: profiler,
      alignment: alignment,
      isRotated: isRotated,
      onComplete: onComplete,
    );
  }

  const GaplyRotate.rotate90({
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

  const GaplyRotate.rotate180({
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

  const GaplyRotate.rotate270({
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

  const GaplyRotate.rotate360({
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
  GaplyRotate copyWith({
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
    return GaplyRotate(
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
  GaplyRotate lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyRotate) return this;

    return profiler.trace(() {
      return GaplyRotate(
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
  GaplyRotate get _self => this as GaplyRotate;
  GaplyRotate get gaplyRotate => _self;

  GaplyRotate copyWithRotate(GaplyRotate rotate) {
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

void _initPresets(GaplyRotatePreset preset) {
  preset.add(
    'tiltRight',
    const GaplyRotate(
      begin: 0,
      end: 5,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      isRotated: true,
    ),
  );

  preset.add(
    'tiltLeft',
    const GaplyRotate(
      begin: 0,
      end: -5,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      isRotated: true,
    ),
  );

  preset.add('flip', const GaplyRotate(begin: 0, end: 180, isRotated: true));

  preset.add('slight', const GaplyRotate(begin: -2, end: 2, isRotated: true));
}
