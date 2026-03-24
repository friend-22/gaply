import 'package:flutter/widgets.dart';

import 'train_style.dart';

extension TrainParamsExtension<T> on T {
  Widget withTrain({
    required T currentItem,
    required T? previousItem,
    required Widget Function(T) itemBuilder,
    required TrainStyle style,
  }) {
    return style.buildTrain(currentItem: currentItem, previousItem: previousItem, itemBuilder: itemBuilder);
  }
}
