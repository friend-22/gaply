import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'scale_widget.dart';
import 'gaply_scale_modifier.dart';

part 'scale_trigger.dart';
part 'gaply_scale.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyScale extends GaplyAnimStyle<GaplyScale>
    with
        GaplyTweenMixin<GaplyScale>,
        GaplyAnimMixin<GaplyScale>,
        _ScaleStyleMixin,
        GaplyScaleModifier<GaplyScale> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const GaplyScale({
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

  const GaplyScale.none()
    : this(
        duration: Duration.zero,
        curve: Curves.linear,
        delay: Duration.zero,
        begin: 0.0,
        end: 1.0,
        isScaled: false,
      );

  static GaplyScalePreset preset = GaplyScalePreset._i;

  factory GaplyScale.of(
    Object key, {
    GaplyProfiler? profiler,
    Alignment? alignment,
    bool? isScaled,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(
      profiler: profiler,
      alignment: alignment,
      isScaled: isScaled,
      onComplete: onComplete,
    );
  }

  @override
  GaplyScale copyWith({
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
    return GaplyScale(
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
  GaplyScale lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyScale) return this;

    return profiler.trace(() {
      return GaplyScale(
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
  GaplyScale get _self => this as GaplyScale;
  GaplyScale get gaplyScale => _self;

  GaplyScale copyWithScale(GaplyScale scale) {
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

void _initPresets(GaplyScalePreset preset) {
  preset.add(
    'pressed',
    const GaplyScale(
      begin: 1.0,
      end: 0.95,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      isScaled: true,
    ),
  );

  preset.add(
    'hover',
    const GaplyScale(
      begin: 1.0,
      end: 1.05,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      isScaled: true,
    ),
  );

  preset.add(
    'popIn',
    const GaplyScale(
      begin: 0.0,
      end: 1.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      isScaled: true,
    ),
  );

  preset.add(
    'shrinkOut',
    const GaplyScale(
      begin: 1.0,
      end: 0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInBack,
      isScaled: true,
    ),
  );
}
