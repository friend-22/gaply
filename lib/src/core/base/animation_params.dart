import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/params_base.dart';

@immutable
abstract class AnimationParams extends ParamsBase<AnimationParams> {
  final Duration duration;
  final Curve curve;
  final VoidCallback? onComplete;

  const AnimationParams({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.onComplete,
  });

  @override
  bool get isEnabled => duration.inMilliseconds > 0;

  @override
  List<Object?> get props => [duration, curve, onComplete];
}

mixin DirectionAnimationParamsMixin {
  AxisDirection get direction;

  Axis get axis => axisDirectionToAxis(direction);
  bool get isReversed => axisDirectionIsReversed(direction);
  bool get isHorizontal => axis == Axis.horizontal;

  AxisDirection get reversedDirection => flipAxisDirection(direction);

  // double get distance;
  // Offset get offset {
  //   return switch (direction) {
  //     AxisDirection.up => Offset(0, -distance),
  //     AxisDirection.down => Offset(0, distance),
  //     AxisDirection.left => Offset(-distance, 0),
  //     AxisDirection.right => Offset(distance, 0),
  //   };
  // }
}
