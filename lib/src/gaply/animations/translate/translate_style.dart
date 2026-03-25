import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'translate_presets.dart';
import 'gaply_translate.dart';

part 'translate_trigger.dart';

@immutable
class TranslateStyle extends GaplyAnimStyle with GaplyAnimMixin<TranslateStyle> {
  final Offset begin;
  final Offset end;
  final bool isMoved;

  const TranslateStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
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

  factory TranslateStyle.preset(String name, {bool? isMoved, VoidCallback? onComplete}) {
    final style = GaplyTranslatePreset.of(name);
    if (style == null) {
      throw ArgumentError(
        'Unknown translate preset: "$name". '
        'Available presets: ${GaplyTranslatePreset.instance.allKeys.join(", ")}',
      );
    }
    return style.copyWith(isMoved: isMoved, onComplete: onComplete);
  }

  @override
  TranslateStyle copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    Offset? begin,
    Offset? end,
    bool? isMoved,
  }) {
    return TranslateStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      isMoved: isMoved ?? this.isMoved,
    );
  }

  @override
  TranslateStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! TranslateStyle) return this;

    return TranslateStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      begin: Offset.lerp(begin, other.begin, t)!,
      end: Offset.lerp(end, other.end, t)!,
      isMoved: t < 0.5 ? isMoved : other.isMoved,
    );
  }

  @override
  List<Object?> get props => [...super.props, begin, end, isMoved];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || isMoved;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!hasEffect) return child;

    return _GaplyTranslateTrigger(style: this, trigger: trigger ?? DateTime.now(), child: child);
  }
}
