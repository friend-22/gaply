import 'package:flutter/animation.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'scale_style.dart';

class GaplyScalePreset with GaplyPreset<ScaleStyle> {
  static final GaplyScalePreset instance = GaplyScalePreset._internal();
  GaplyScalePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'pop',
      const ScaleStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        begin: 0.0,
        end: 1.1,
        isScaled: true,
      ),
    );
    add(
      'shrink',
      const ScaleStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        begin: 1.0,
        end: 0.0,
        isScaled: true,
      ),
    );
    add(
      'grow',
      const ScaleStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        begin: 0.0,
        end: 1.0,
        isScaled: true,
      ),
    );
  }

  static void register(String name, ScaleStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static ScaleStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
