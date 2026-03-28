import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'fade_presets.dart';
import 'gaply_fade.dart';
import 'fade_style_modifier.dart';

part 'fade_trigger.dart';

/// A configuration style for fade (opacity) animations.
///
/// [FadeStyle] controls how a widget transitions between transparent and opaque.
/// It integrates with the Gaply animation system to provide smooth [FadeTransition]s.
///
/// ### Example Usage:
///
/// ```dart
/// final fadeStyle = FadeStyle(
///   visible: true,
///   duration: Duration(milliseconds: 500),
///   curve: Curves.easeIn,
///   delay: Duration(milliseconds: 200),
/// );
/// ```
@immutable
class FadeStyle extends GaplyAnimStyle<FadeStyle>
    with
        GaplyTweenMixin<FadeStyle>,
        GaplyAnimMixin<FadeStyle>,
        _FadeStyleMixin,
        FadeStyleModifier<FadeStyle> {
  /// Whether the widget should be visible (opaque) or hidden (transparent).
  ///
  /// - If `true`, the widget fades in to an opacity of 1.0.
  /// - If `false`, the widget fades out to an opacity of 0.0.
  final bool isVisible;

  const FadeStyle({
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

  const FadeStyle.none() : this(duration: Duration.zero, isVisible: false);

  /// Creates a [FadeStyle] from a pre-defined preset name.
  ///
  /// Available default presets: 'fadeIn', 'fadeOut'.
  /// Throws [ArgumentError] if the [name] is not registered.
  static void register(Object name, FadeStyle style) => GaplyFadePreset.register(name, style);

  factory FadeStyle.preset(Object name, {GaplyProfiler? profiler, VoidCallback? onComplete}) {
    final style = GaplyFadePreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyFadePreset.instance.errorMessage("FadeStyle", name));
    }
    return style.copyWith(profiler: profiler, onComplete: onComplete);
  }

  const FadeStyle.fadeIn({
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

  const FadeStyle.fadeOut({
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
  FadeStyle copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    bool? isVisible,
  }) {
    return FadeStyle(
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
  FadeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! FadeStyle) return this;

    return profiler.trace(() {
      return FadeStyle(
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
  FadeStyle get _self => this as FadeStyle;
  FadeStyle get fadeStyle => _self;

  FadeStyle copyWithFade(FadeStyle fade) {
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
