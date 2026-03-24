import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_slide.dart';
import 'slide_preset.dart';

part 'slide_trigger.dart';

@immutable
class SlideStyle extends GaplyAnimStyle with GaplyAnimMixin<SlideStyle>, GaplyDirectionAnimMixin {
  @override
  final AxisDirection direction;
  final bool visible;
  final bool fixedSize;
  final bool useOpacity;

  const SlideStyle({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.direction,
    this.visible = true,
    this.fixedSize = false,
    this.useOpacity = true,
  });

  const SlideStyle.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, visible: false);

  static void register(String name, SlideStyle style) => GaplySlidePreset.register(name, style);

  factory SlideStyle.preset(
    String name, {
    AxisDirection? direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
    VoidCallback? onComplete,
  }) {
    final style = GaplySlidePreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown slide preset: "$name"');
    }
    return style.copyWith(
      direction: direction,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
      onComplete: onComplete,
    );
  }

  SlideStyle get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  SlideStyle copyWith({
    AxisDirection? direction,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    return SlideStyle(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      visible: visible ?? this.visible,
      fixedSize: fixedSize ?? this.fixedSize,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  @override
  SlideStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SlideStyle) return this;

    return SlideStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      direction: t < 0.5 ? direction : other.direction,
      visible: t < 0.5 ? visible : other.visible,
      fixedSize: t < 0.5 ? fixedSize : other.fixedSize,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }

  @override
  List<Object?> get props => [...super.props, visible, fixedSize, useOpacity];

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!isEnabled) return child;

    return _GaplySlideTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
