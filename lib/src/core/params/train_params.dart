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
    required this.direction,
    this.useOpacity = true,
  });

  const TrainParams.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, useOpacity: false);

  factory TrainParams.preset(String name, {bool? useOpacity}) {
    final params = GaplyTrainPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown train preset: "$name"');
    }
    return useOpacity != null ? params.copyWith(useOpacity: useOpacity) : params;
  }

  TrainParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
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
    return TrainTrigger<T>(
      currentItem: currentItem,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      trigger: DateTime.now(),
      params: this,
    );
  }
}

extension TrainParamsExtension<T> on T {
  Widget withTrain({
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    required TrainParams params,
  }) {
    return TrainTrigger<T>(
      currentItem: this,
      previousItem: previousItem,
      itemBuilder: itemBuilder,
      trigger: DateTime.now(),
      params: params,
    );
  }
}

class GaplyTrainPreset with GaplyPreset<TrainParams> {
  static final GaplyTrainPreset instance = GaplyTrainPreset._internal();
  GaplyTrainPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'left',
      const TrainParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.left,
      ),
    );
    add(
      'right',
      const TrainParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.right,
      ),
    );
    add(
      'up',
      const TrainParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.up,
      ),
    );
    add(
      'down',
      const TrainParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.down,
      ),
    );
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
