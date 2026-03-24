import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'train_style.dart';

class GaplyTrainPreset with GaplyPreset<TrainStyle> {
  static final GaplyTrainPreset instance = GaplyTrainPreset._internal();
  GaplyTrainPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'left',
      const TrainStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.left,
      ),
    );
    add(
      'right',
      const TrainStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.right,
      ),
    );
    add(
      'up',
      const TrainStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.up,
      ),
    );
    add(
      'down',
      const TrainStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.down,
      ),
    );
  }

  static void register(String name, TrainStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static TrainStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
