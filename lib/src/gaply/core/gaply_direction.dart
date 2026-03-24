import 'package:flutter/widgets.dart';

mixin GaplyDirectionAnimMixin {
  AxisDirection get direction;

  Axis get axis => axisDirectionToAxis(direction);
  bool get isReversed => axisDirectionIsReversed(direction);
  bool get isHorizontal => axis == Axis.horizontal;

  AxisDirection get reversedDirection => flipAxisDirection(direction);
}
