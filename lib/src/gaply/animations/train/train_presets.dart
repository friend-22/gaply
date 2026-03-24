import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'train_style.dart';

class GaplyTrainPreset with GaplyPreset<TrainStyle> {
  static final GaplyTrainPreset instance = GaplyTrainPreset._internal();
  GaplyTrainPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'express',
      const TrainStyle(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
        direction: AxisDirection.right,
      ),
    );

    add(
      'link',
      const TrainStyle(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        direction: AxisDirection.left,
      ),
    );

    add(
      'scenic',
      const TrainStyle(
        duration: Duration(milliseconds: 1200),
        curve: Curves.linearToEaseOut,
        direction: AxisDirection.right,
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
