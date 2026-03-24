import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'fade_presets.dart';
import 'gaply_fade.dart';

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
class FadeStyle extends GaplyAnimStyle with GaplyAnimMixin<FadeStyle> {
  /// Whether the widget should be visible (opaque) or hidden (transparent).
  ///
  /// - If `true`, the widget fades in to an opacity of 1.0.
  /// - If `false`, the widget fades out to an opacity of 0.0.
  final bool isVisible;

  const FadeStyle({
    super.duration = const Duration(milliseconds: 500),
    super.curve = Curves.easeInOut,
    super.delay = Duration.zero,
    super.onComplete,
    required this.isVisible,
  });

  const FadeStyle.none() : this(duration: Duration.zero, isVisible: false);

  /// Creates a [FadeStyle] from a pre-defined preset name.
  ///
  /// Available default presets: 'fadeIn', 'fadeOut'.
  /// Throws [ArgumentError] if the [name] is not registered.
  static void register(String name, FadeStyle style) => GaplyFadePreset.register(name, style);

  factory FadeStyle.preset(String name, {VoidCallback? onComplete}) {
    final style = GaplyFadePreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown fade preset: "$name". '
        'Available presets: ${GaplyFadePreset.instance.allKeys.join(", ")}',
      );
    }

    return (onComplete != null) ? style.copyWith(onComplete: onComplete) : style;
  }

  const FadeStyle.fadeIn({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) : this(duration: duration, curve: curve, delay: delay, onComplete: onComplete, isVisible: true);

  const FadeStyle.fadeOut({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOut,
    VoidCallback? onComplete,
  }) : this(duration: duration, curve: curve, delay: delay, onComplete: onComplete, isVisible: false);

  @override
  FadeStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    bool? isVisible,
  }) {
    return FadeStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  FadeStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! FadeStyle) return this;

    return FadeStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      isVisible: t < 0.5 ? isVisible : other.isVisible,
    );
  }

  @override
  List<Object?> get props => [...super.props, isVisible];

  //todo : isEnabled 정리하자
  @override
  bool get isEnabled => duration.inMilliseconds > 0;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplyFadeTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
