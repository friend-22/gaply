import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'fade_presets.dart';
import 'gaply_fade.dart';

part 'fade_trigger.dart';

@immutable
class FadeStyle extends GaplyAnimStyle with GaplyAnimMixin<FadeStyle> {
  final bool visible;

  const FadeStyle({super.duration, super.curve, super.onComplete, super.delay, required this.visible});

  const FadeStyle.none() : this(duration: Duration.zero, visible: false);

  static void register(String name, FadeStyle style) => GaplyFadePreset.register(name, style);

  factory FadeStyle.preset(String name, {VoidCallback? onComplete}) {
    final style = GaplyFadePreset.of(name);

    if (style == null) {
      throw ArgumentError('Unknown fade preset: "$name"');
    }

    return (onComplete != null) ? style.copyWith(onComplete: onComplete) : style;
  }

  @override
  FadeStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    bool? visible,
  }) {
    return FadeStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      visible: visible ?? this.visible,
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
      visible: t < 0.5 ? visible : other.visible,
    );
  }

  @override
  List<Object?> get props => [...super.props, visible];

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplyFadeTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
