import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_trigger.dart';

import 'gaply_train.dart';
import 'train_presets.dart';

part 'train_trigger.dart';

@immutable
class TrainStyle extends GaplyAnimStyle with GaplyAnimMixin<TrainStyle>, GaplyDirectionAnimMixin {
  @override
  final AxisDirection direction;
  final bool useOpacity;

  const TrainStyle({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.direction,
    this.useOpacity = true,
  });

  const TrainStyle.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, useOpacity: false);

  static void register(String name, TrainStyle style) => GaplyTrainPreset.register(name, style);

  factory TrainStyle.preset(String name, {bool? useOpacity, VoidCallback? onComplete}) {
    final style = GaplyTrainPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown train preset: "$name"');
    }
    return style.copyWith(useOpacity: useOpacity, onComplete: onComplete);
  }

  TrainStyle get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  TrainStyle copyWith({
    AxisDirection? direction,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    bool? useOpacity,
  }) {
    return TrainStyle(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  @override
  TrainStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! TrainStyle) return this;

    return TrainStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
      direction: t < 0.5 ? direction : other.direction,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }

  @override
  List<Object?> get props => [...super.props, useOpacity];

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return child;
  }

  Widget buildTrain<T>({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
  }) {
    return _GaplyTrainTrigger<T>(
      currentItem: currentItem,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      trigger: DateTime.now(),
      style: this,
    );
  }
}
