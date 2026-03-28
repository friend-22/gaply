import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/utils/gaply_perf.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'translate_presets.dart';
import 'translate_style_modifier.dart';
import 'gaply_translate.dart';

part 'translate_trigger.dart';

@immutable
class TranslateStyle extends GaplyAnimStyle<TranslateStyle>
    with
        GaplyTweenMixin<TranslateStyle>,
        GaplyAnimMixin<TranslateStyle>,
        _GaplyTranslateMixin,
        TranslateStyleModifier<TranslateStyle> {
  final Offset begin;
  final Offset end;
  final bool isMoved;

  const TranslateStyle({
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

  const TranslateStyle.none()
    : this(duration: Duration.zero, curve: Curves.linear, end: Offset.zero, isMoved: false);

  static void register(String name, TranslateStyle style) => GaplyTranslatePreset.register(name, style);

  factory TranslateStyle.preset(
    String name, {
    GaplyProfiler? profiler,
    bool? isMoved,
    VoidCallback? onComplete,
  }) {
    final style = GaplyTranslatePreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyTranslatePreset.instance.errorMessage("TranslateStyle", name));
    }
    return style.copyWith(profiler: profiler, isMoved: isMoved, onComplete: onComplete);
  }

  @override
  TranslateStyle copyWith({
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
    return TranslateStyle(
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
  TranslateStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! TranslateStyle) return this;

    return profiler.trace(() {
      return TranslateStyle(
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
  TranslateStyle get _self => this as TranslateStyle;
  TranslateStyle get translateStyle => _self;

  TranslateStyle copyWithTranslate(TranslateStyle translate) {
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
