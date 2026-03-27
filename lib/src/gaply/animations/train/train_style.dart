import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_train.dart';
import 'train_presets.dart';
import 'train_style_modifier.dart';

part 'train_trigger.dart';

@immutable
class TrainStyle extends GaplyAnimStyle<TrainStyle>
    with
        GaplyTweenMixin<TrainStyle>,
        GaplyAnimMixin<TrainStyle>,
        GaplyDirectionAnimMixin,
        _TrainStyleMixin,
        TrainStyleModifier<TrainStyle> {
  @override
  final AxisDirection direction;
  final bool useOpacity;

  const TrainStyle({
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

  const TrainStyle.none() : this(duration: Duration.zero, direction: AxisDirection.down);

  static void register(String name, TrainStyle style) => GaplyTrainPreset.register(name, style);

  factory TrainStyle.preset(String name, {bool? useOpacity, VoidCallback? onComplete}) {
    final style = GaplyTrainPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyTrainPreset.instance.errorMessage("TrainStyle", name));
    }
    return style.copyWith(useOpacity: useOpacity, onComplete: onComplete);
  }

  const TrainStyle.left({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.left,
         useOpacity: useOpacity,
       );

  const TrainStyle.right({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.right,
         useOpacity: useOpacity,
       );

  const TrainStyle.up({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.up,
         useOpacity: useOpacity,
       );

  const TrainStyle.down({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool useOpacity = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.down,
         useOpacity: useOpacity,
       );

  TrainStyle get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  TrainStyle copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    AxisDirection? direction,
    bool? useOpacity,
  }) {
    return TrainStyle(
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
  TrainStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! TrainStyle) return this;

    return TrainStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      delay: t < 0.5 ? delay : other.delay,
      onComplete: other.onComplete,
      progress: lerpDouble(progress, other.progress, t) ?? other.progress,
      direction: t < 0.5 ? direction : other.direction,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }

  @override
  List<Object?> get props => [...super.props, direction, useOpacity];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _TrainStyleMixin {
  TrainStyle get trainStyle => this as TrainStyle;

  TrainStyle copyWithTrain(TrainStyle train) {
    return trainStyle.copyWith(
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
      style: trainStyle,
    );
  }
}
