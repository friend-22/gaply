import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'slide_style.dart';

class GaplySlidePreset with GaplyPreset<SlideStyle> {
  static final GaplySlidePreset instance = GaplySlidePreset._internal();
  GaplySlidePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'left',
      const SlideStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.left,
      ),
    );
    add(
      'right',
      const SlideStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.right,
      ),
    );
    add(
      'up',
      const SlideStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.up,
      ),
    );
    add(
      'down',
      const SlideStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.down,
      ),
    );
  }

  static void register(String name, SlideStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static SlideStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
