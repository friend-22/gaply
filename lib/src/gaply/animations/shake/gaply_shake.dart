import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply_base.dart';

import 'shake_widget.dart';
import 'gaply_shake_modifier.dart';

part 'shake_trigger.dart';
part 'gaply_shake.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyShake extends GaplyAnimStyle<GaplyShake>
    with
        GaplyTweenMixin<GaplyShake>,
        GaplyAnimMixin<GaplyShake>,
        _ShakeStyleMixin,
        GaplyShakeModifier<GaplyShake> {
  final double distance;
  final double count;
  final bool useHaptic;
  final bool useRepaintBoundary;
  final bool isVertical;

  const GaplyShake({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    this.distance = 8.0,
    this.count = 4.0,
    this.useHaptic = true,
    this.useRepaintBoundary = true,
    this.isVertical = false,
  }) : assert(distance >= 0, 'distance must be non-negative'),
       assert(count > 0, 'count must be positive'),
       super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.linear,
         delay: delay ?? Duration.zero,
       );

  const GaplyShake.none() : this(duration: Duration.zero, distance: 0.0, count: 0.0);

  static GaplyShakePreset preset = GaplyShakePreset._i;

  factory GaplyShake.of(
    Object key, {
    GaplyProfiler? profiler,
    double? distance,
    double? count,
    bool? isVertical,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(
      profiler: profiler,

      distance: distance,
      count: count,
      isVertical: isVertical,
      onComplete: onComplete,
    );
  }

  /// Returns a new [GaplyShake] with intensity multiplied by [intensity].
  ///
  /// Both distance and count are scaled proportionally.
  GaplyShake withIntensityScale(double intensity, {GaplyProfiler? profiler}) {
    assert(intensity >= 0, 'intensity must be non-negative');
    return copyWith(
      profiler: profiler,
      distance: distance * intensity,
      count: (count * intensity).toDouble(),
    );
  }

  @override
  GaplyShake copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    double? distance,
    double? count,
    bool? useHaptic,
    bool? useRepaintBoundary,
    bool? isVertical,
  }) {
    return GaplyShake(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      distance: distance ?? this.distance,
      count: count ?? this.count,
      useHaptic: useHaptic ?? this.useHaptic,
      useRepaintBoundary: useRepaintBoundary ?? this.useRepaintBoundary,
      isVertical: isVertical ?? this.isVertical,
    );
  }

  @override
  GaplyShake lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyShake) return this;

    return profiler.trace(() {
      return GaplyShake(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        distance: lerpDouble(distance, other.distance, t) ?? distance,
        count: lerpDouble(count, other.count, t) ?? count,
        useHaptic: t < 0.5 ? useHaptic : other.useHaptic,
        useRepaintBoundary: t < 0.5 ? useRepaintBoundary : other.useRepaintBoundary,
        isVertical: t < 0.5 ? isVertical : other.isVertical,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, distance, count, useHaptic, useRepaintBoundary, isVertical];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 && distance > 0 && count > 0;
}

mixin _ShakeStyleMixin {
  GaplyShake get _self => this as GaplyShake;
  GaplyShake get gaplyShake => _self;

  GaplyShake copyWithShake(GaplyShake shake) {
    return _self.copyWith(
      profiler: shake.profiler,
      duration: shake.duration,
      curve: shake.curve,
      delay: shake.delay,
      onComplete: shake.onComplete,
      progress: shake.progress,
      distance: shake.distance,
      count: shake.count,
      useHaptic: shake.useHaptic,
      useRepaintBoundary: shake.useRepaintBoundary,
      isVertical: shake.isVertical,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplyShakeTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}

void _initPresets(GaplyShakePreset preset) {
  preset.add(
    'mild',
    const GaplyShake(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      distance: 3.0,
      count: 2.0,
    ),
  );

  preset.add(
    'normal',
    const GaplyShake(duration: Duration(milliseconds: 400), curve: Curves.linear, distance: 6.0, count: 3.0),
  );

  preset.add(
    'severe',
    const GaplyShake(duration: Duration(milliseconds: 500), curve: Curves.linear, distance: 10.0, count: 5.0),
  );

  preset.add(
    'alert',
    const GaplyShake(duration: Duration(milliseconds: 200), curve: Curves.linear, distance: 4.0, count: 6.0),
  );

  preset.add(
    'nod',
    const GaplyShake(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      distance: 5.0,
      count: 2.0,
      isVertical: true,
    ),
  );

  preset.add(
    'celebrate',
    const GaplyShake(
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate,
      distance: 10.0,
      count: 3.0,
      isVertical: true,
    ),
  );
}
