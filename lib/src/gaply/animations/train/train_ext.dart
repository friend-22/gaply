import 'package:flutter/widgets.dart';

import 'gaply_train.dart';

extension TrainParamsExtension<T> on T {
  Widget withTrain({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    required GaplyTrain style,
  }) {
    return style.buildTrain(currentItem: currentItem, previousItem: previousItem, itemBuilder: itemBuilder);
  }
}
