import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/train_widget.dart';

import '../base/animation_params.dart';

@immutable
class TrainParams extends AnimationParams with DirectionAnimationParamsMixin {
  @override
  final AxisDirection direction;
  final bool useOpacity;

  const TrainParams({
    super.duration,
    super.curve,
    super.onComplete,
    this.direction = AxisDirection.down,
    this.useOpacity = true,
  });

  factory TrainParams.preset(String name, {bool? useOpacity}) {
    final params = GaplyTrainPreset.of(name) ?? GaplyTrainPreset.of('none')!;
    return params.copyWith(useOpacity: useOpacity);
  }

  factory TrainParams.fast(String name, {bool? useOpacity}) {
    final params = GaplyTrainPreset.of(name) ?? GaplyTrainPreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 300), useOpacity: useOpacity);
  }

  factory TrainParams.slow(String name, {bool? useOpacity}) {
    final params = GaplyTrainPreset.of(name) ?? GaplyTrainPreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 800), useOpacity: useOpacity);
  }

  factory TrainParams.elastic(
    AxisDirection direction, {
    Duration duration = const Duration(milliseconds: 400),
    bool useOpacity = true,
    VoidCallback? onComplete,
  }) {
    return TrainParams(
      direction: direction,
      duration: duration,
      curve: Curves.elasticOut,
      useOpacity: useOpacity,
      onComplete: onComplete,
    );
  }

  factory TrainParams.bounce(
    AxisDirection direction, {
    Duration duration = const Duration(milliseconds: 500),
    bool useOpacity = true,
    VoidCallback? onComplete,
  }) {
    return TrainParams(
      direction: direction,
      duration: duration,
      curve: Curves.bounceOut,
      useOpacity: useOpacity,
      onComplete: onComplete,
    );
  }

  TrainParams get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  List<Object?> get props => [...super.props, useOpacity];

  @override
  TrainParams copyWith({
    AxisDirection? direction,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    bool? useOpacity,
  }) {
    return TrainParams(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  @override
  TrainParams lerp(AnimationParams? other, double t) {
    if (other is! TrainParams) return this;
    return TrainParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      direction: t < 0.5 ? direction : other.direction,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }

  Widget buildWidget<T>({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
  }) {
    return TrainWidget<T>(
      currentItem: currentItem,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      params: this,
    );
  }
}

extension TrainParamsExtension<T> on T {
  Widget withTrain({
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    TrainParams params = const TrainParams(),
  }) {
    return TrainWidget<T>(
      currentItem: this,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      params: params,
    );
  }
}

class GaplyTrainPreset with GaplyPreset<TrainParams> {
  static final GaplyTrainPreset instance = GaplyTrainPreset._internal();
  GaplyTrainPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
    add('none', const TrainParams(duration: Duration.zero));
    add('left', const TrainParams(direction: AxisDirection.left));
    add('right', const TrainParams(direction: AxisDirection.right));
    add('up', const TrainParams(direction: AxisDirection.up));
    add('down', const TrainParams(direction: AxisDirection.down));
  }

  static void register(String name, TrainParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static TrainParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
