import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'gaply_translate_modifier.dart';
import 'translate_widget.dart';

part 'translate_trigger.dart';
part 'gaply_translate.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyTranslate extends GaplyAnimStyle<GaplyTranslate>
    with
        GaplyTweenMixin<GaplyTranslate>,
        GaplyAnimMixin<GaplyTranslate>,
        _GaplyTranslateMixin,
        GaplyTranslateModifier<GaplyTranslate> {
  final Offset begin;
  final Offset end;
  final bool isMoved;

  const GaplyTranslate({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.end,
    required this.isMoved,
    this.begin = Offset.zero,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.easeInOut,
         delay: delay ?? Duration.zero,
       );

  const GaplyTranslate.none()
    : this(duration: Duration.zero, curve: Curves.linear, end: Offset.zero, isMoved: false);

  static GaplyTranslatePreset preset = GaplyTranslatePreset._i;

  factory GaplyTranslate.of(Object key, {GaplyProfiler? profiler, bool? isMoved, VoidCallback? onComplete}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, isMoved: isMoved, onComplete: onComplete);
  }

  @override
  GaplyTranslate copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Offset? begin,
    Offset? end,
    bool? isMoved,
  }) {
    return GaplyTranslate(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      isMoved: isMoved ?? this.isMoved,
    );
  }

  @override
  GaplyTranslate lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyTranslate) return this;

    return profiler.trace(() {
      return GaplyTranslate(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        begin: Offset.lerp(begin, other.begin, t)!,
        end: Offset.lerp(end, other.end, t)!,
        isMoved: t < 0.5 ? isMoved : other.isMoved,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, begin, end, isMoved];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || isMoved;
}

mixin _GaplyTranslateMixin {
  GaplyTranslate get _self => this as GaplyTranslate;
  GaplyTranslate get gaplyTranslate => _self;

  GaplyTranslate copyWithTranslate(GaplyTranslate translate) {
    return _self.copyWith(
      profiler: translate.profiler,
      duration: translate.duration,
      curve: translate.curve,
      delay: translate.delay,
      onComplete: translate.onComplete,
      progress: translate.progress,
      begin: translate.begin,
      end: translate.end,
      isMoved: translate.isMoved,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyTranslateTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}

void _initPresets(GaplyTranslatePreset preset) {
  preset.add(
    'push',
    const GaplyTranslate(
      begin: Offset.zero,
      end: Offset(0, 2),
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOutQuad,
      isMoved: true,
    ),
  );

  preset.add(
    'float',
    const GaplyTranslate(
      begin: Offset.zero,
      end: Offset(0, -4),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      isMoved: true,
    ),
  );

  preset.add(
    'nudge',
    const GaplyTranslate(
      begin: Offset.zero,
      end: Offset(6, 0),
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      isMoved: true,
    ),
  );

  preset.add(
    'rise',
    const GaplyTranslate(
      begin: Offset(0, 10),
      end: Offset.zero,
      duration: Duration(milliseconds: 400),
      curve: Curves.decelerate,
      isMoved: true,
    ),
  );
}
