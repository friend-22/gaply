import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/inner_gaply_base.dart';

import 'skew_widget.dart';
import 'gaply_skew_modifier.dart';

part 'skew_trigger.dart';
part 'gaply_skew.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplySkew extends GaplyAnimStyle<GaplySkew>
    with
        GaplyTweenMixin<GaplySkew>,
        GaplyAnimMixin<GaplySkew>,
        _SkewStyleMixin,
        GaplySkewModifier<GaplySkew> {
  final Offset skew;
  final bool isSkewed;

  const GaplySkew({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.skew,
    required this.isSkewed,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const GaplySkew.none() : this(duration: Duration.zero, skew: Offset.zero, isSkewed: false);

  static GaplySkewPreset preset = GaplySkewPreset._i;

  factory GaplySkew.of(Object key, {GaplyProfiler? profiler, bool? isSkewed, VoidCallback? onComplete}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, isSkewed: isSkewed, onComplete: onComplete);
  }

  GaplySkew.horizontal(
    double amount, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(amount, 0),
         isSkewed: isSkewed,
       );

  GaplySkew.vertical(
    double amount, {
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isSkewed = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         skew: Offset(0, amount),
         isSkewed: isSkewed,
       );

  @override
  GaplySkew copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Offset? skew,
    bool? isSkewed,
  }) {
    return GaplySkew(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      skew: skew ?? this.skew,
      isSkewed: isSkewed ?? this.isSkewed,
    );
  }

  @override
  GaplySkew lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplySkew) return this;

    return profiler.trace(() {
      return GaplySkew(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        skew: Offset.lerp(skew, other.skew, t)!,
        isSkewed: t < 0.5 ? isSkewed : other.isSkewed,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, skew, isSkewed];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || isSkewed;
}

mixin _SkewStyleMixin {
  GaplySkew get _self => this as GaplySkew;
  GaplySkew get gaplySkew => _self;

  GaplySkew copyWithSkew(GaplySkew skew) {
    return _self.copyWith(
      profiler: skew.profiler,
      duration: skew.duration,
      curve: skew.curve,
      delay: skew.delay,
      onComplete: skew.onComplete,
      progress: skew.progress,
      skew: skew.skew,
      isSkewed: skew.isSkewed,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplySkewTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}

void _initPresets(GaplySkewPreset preset) {
  preset.add('tiltRight', GaplySkew.horizontal(0.1));

  preset.add('tiltUp', GaplySkew.vertical(-0.1));

  preset.add(
    'bounceSkew',
    GaplySkew.horizontal(0.2, duration: Duration(milliseconds: 600), curve: Curves.elasticOut),
  );

  preset.add('flipPre', GaplySkew.horizontal(0.5, curve: Curves.easeInCubic));
}
