import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'skew_presets.dart';
import 'gaply_skew.dart';

import 'skew_style_modifier.dart';

part 'skew_trigger.dart';

@immutable
class SkewStyle extends GaplyAnimStyle
    with GaplyAnimMixin<SkewStyle>, _SkewStyleMixin, SkewStyleModifier<SkewStyle> {
  final Offset skew;
  final bool isSkewed;

  const SkewStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    required this.skew,
    required this.isSkewed,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const SkewStyle.none() : this(duration: Duration.zero, skew: Offset.zero, isSkewed: false);

  static void register(String name, SkewStyle style) => GaplySkewPreset.register(name, style);

  factory SkewStyle.preset(String name, {bool? isSkewed, VoidCallback? onComplete}) {
    final style = GaplySkewPreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown skew preset: "$name". '
        'Available presets: ${GaplySkewPreset.instance.allKeys.join(", ")}',
      );
    }

    return style.copyWith(isSkewed: isSkewed, onComplete: onComplete);
  }

  SkewStyle.horizontal(
    double amount, {
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(amount, 0),
         isSkewed: isSkewed,
       );

  SkewStyle.vertical(
    double amount, {
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(0, amount),
         isSkewed: isSkewed,
       );

  @override
  SkewStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    Offset? skew,
    bool? isSkewed,
  }) {
    return SkewStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      skew: skew ?? this.skew,
      isSkewed: isSkewed ?? this.isSkewed,
    );
  }

  @override
  SkewStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! SkewStyle) return this;

    return SkewStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      skew: Offset.lerp(skew, other.skew, t)!,
      isSkewed: t < 0.5 ? isSkewed : other.isSkewed,
    );
  }

  @override
  List<Object?> get props => [...super.props, skew, isSkewed];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || isSkewed;
}

mixin _SkewStyleMixin {
  SkewStyle get skewStyle => this as SkewStyle;

  SkewStyle copyWithSkew(SkewStyle skew) {
    return skewStyle.copyWith(
      duration: skew.duration,
      curve: skew.curve,
      delay: skew.delay,
      onComplete: skew.onComplete,
      skew: skew.skew,
      isSkewed: skew.isSkewed,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!skewStyle.hasEffect) return child;

    return _GaplySkewTrigger(style: skewStyle, trigger: trigger ?? DateTime.now(), child: child);
  }
}
