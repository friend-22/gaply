import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply_base.dart';

import 'train_widget.dart';
import 'gaply_train_modifier.dart';

part 'train_trigger.dart';
part 'gaply_train.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyTrain extends GaplyAnimStyle<GaplyTrain>
    with
        GaplyTweenMixin<GaplyTrain>,
        GaplyAnimMixin<GaplyTrain>,
        GaplyDirectionAnimMixin,
        _TrainStyleMixin,
        GaplyTrainModifier<GaplyTrain> {
  @override
  final AxisDirection direction;
  final bool useOpacity;

  const GaplyTrain({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.direction,
    this.useOpacity = true,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 500),
         curve: curve ?? Curves.easeOutQuart,
         delay: delay ?? Duration.zero,
       );

  const GaplyTrain.none() : this(duration: Duration.zero, direction: AxisDirection.down);

  static GaplyTrainPreset preset = GaplyTrainPreset._i;

  factory GaplyTrain.of(Object key, {GaplyProfiler? profiler, bool? useOpacity, VoidCallback? onComplete}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, useOpacity: useOpacity, onComplete: onComplete);
  }

  const GaplyTrain.left({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.left,
         useOpacity: useOpacity,
       );

  const GaplyTrain.right({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.right,
         useOpacity: useOpacity,
       );

  const GaplyTrain.up({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.up,
         useOpacity: useOpacity,
       );

  const GaplyTrain.down({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.down,
         useOpacity: useOpacity,
       );

  GaplyTrain get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  GaplyTrain copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    AxisDirection? direction,
    bool? useOpacity,
  }) {
    return GaplyTrain(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      direction: direction ?? this.direction,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  @override
  GaplyTrain lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyTrain) return this;

    return profiler.trace(() {
      return GaplyTrain(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        direction: t < 0.5 ? direction : other.direction,
        useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, direction, useOpacity];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _TrainStyleMixin {
  GaplyTrain get _self => this as GaplyTrain;
  GaplyTrain get gaplyTrain => _self;

  GaplyTrain copyWithTrain(GaplyTrain train) {
    return _self.copyWith(
      profiler: train.profiler,
      duration: train.duration,
      curve: train.curve,
      delay: train.delay,
      onComplete: train.onComplete,
      progress: train.progress,
      direction: train.direction,
      useOpacity: train.useOpacity,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    return child;
  }

  Widget buildTrain<T>({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    Object? trigger,
  }) {
    return _GaplyTrainTrigger<T>(
      currentItem: currentItem,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      trigger: DateTime.now(),
      style: _self,
    );
  }
}

void _initPresets(GaplyTrainPreset preset) {
  preset.add(
    'express',
    const GaplyTrain(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutExpo,
      direction: AxisDirection.right,
    ),
  );

  preset.add(
    'link',
    const GaplyTrain(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      direction: AxisDirection.left,
    ),
  );

  preset.add(
    'scenic',
    const GaplyTrain(
      duration: Duration(milliseconds: 1200),
      curve: Curves.linearToEaseOut,
      direction: AxisDirection.right,
    ),
  );
}
