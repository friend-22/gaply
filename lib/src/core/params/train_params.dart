part of '../gaply_animation.dart';

@immutable
class TrainParams extends AnimationParams
    with AnimationParamsWithMixin<TrainParams>, DirectionAnimationParamsMixin {
  @override
  final AxisDirection direction;
  final bool useOpacity;

  const TrainParams({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.direction,
    this.useOpacity = true,
  }) : super(internalComplete: null);

  const TrainParams._internal({
    required super.duration,
    required super.curve,
    required super.delay,
    required super.onComplete,
    required super.internalComplete,
    required this.direction,
    required this.useOpacity,
  });

  const TrainParams.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, useOpacity: false);

  factory TrainParams.preset(String name, {bool? useOpacity, VoidCallback? onComplete}) {
    final params = GaplyTrainPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown train preset: "$name"');
    }
    return params.copyWith(useOpacity: useOpacity, onComplete: onComplete);
  }

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return child;
  }

  Widget buildTrain<T>({
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
    Duration? delay,
    bool? useOpacity,
  }) {
    return TrainParams._internal(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      internalComplete: _internalComplete,
      delay: delay ?? this.delay,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  TrainParams copyWithInternal({VoidCallback? internalComplete}) {
    return TrainParams._internal(
      direction: direction,
      duration: duration,
      curve: curve,
      delay: delay,
      onComplete: onComplete,
      internalComplete: internalComplete ?? _internalComplete,
      useOpacity: useOpacity,
    );
  }

  @override
  TrainParams lerp(AnimationParams? other, double t) {
    if (other is! TrainParams) return this;

    return TrainParams._internal(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      internalComplete: other._internalComplete,
      delay: t < 0.5 ? delay : other.delay,
      direction: t < 0.5 ? direction : other.direction,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }
}

extension TrainParamsExtension<T> on T {
  Widget withTrain({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    required TrainParams params,
  }) {
    return params.buildTrain(currentItem: currentItem, previousItem: previousItem, itemBuilder: itemBuilder);
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
