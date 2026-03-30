import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'fade_widget.dart';
import 'gaply_fade_modifier.dart';

part 'fade_trigger.dart';
part 'gaply_fade.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyFade extends GaplyAnimStyle<GaplyFade>
    with
        GaplyTweenMixin<GaplyFade>,
        GaplyAnimMixin<GaplyFade>,
        _FadeStyleMixin,
        GaplyFadeModifier<GaplyFade> {
  final bool isVisible;

  const GaplyFade({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.isVisible,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.easeInOut,
         delay: delay ?? Duration.zero,
       );

  const GaplyFade.none() : this(duration: Duration.zero, isVisible: false);

  static GaplyFadePreset preset = GaplyFadePreset._i;

  factory GaplyFade.of(Object key, {GaplyProfiler? profiler, VoidCallback? onComplete}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, onComplete: onComplete);
  }

  const GaplyFade.fadeIn({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         isVisible: true,
       );

  const GaplyFade.fadeOut({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve ?? Curves.easeOut,
         delay: delay,
         onComplete: onComplete,
         isVisible: false,
       );

  @override
  GaplyFade copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    bool? isVisible,
  }) {
    return GaplyFade(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  GaplyFade lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyFade) return this;

    return profiler.trace(() {
      return GaplyFade(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        isVisible: t < 0.5 ? isVisible : other.isVisible,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, isVisible];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _FadeStyleMixin {
  GaplyFade get _self => this as GaplyFade;
  GaplyFade get gaplyFade => _self;

  GaplyFade copyWithFade(GaplyFade fade) {
    return _self.copyWith(
      profiler: fade.profiler,
      duration: fade.duration,
      curve: fade.curve,
      delay: fade.delay,
      onComplete: fade.onComplete,
      progress: fade.progress,
      isVisible: fade.isVisible,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyFadeTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}

void _initPresets(GaplyFadePreset preset) {}
