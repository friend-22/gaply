import 'package:flutter/animation.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'scale_style.dart';

class GaplyScalePreset with GaplyPreset<ScaleStyle> {
  static final GaplyScalePreset instance = GaplyScalePreset._internal();

  GaplyScalePreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'pressed',
      const ScaleStyle(
        begin: 1.0,
        end: 0.95,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        isScaled: true,
      ),
    );

    add(
      'hover',
      const ScaleStyle(
        begin: 1.0,
        end: 1.05,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        isScaled: true,
      ),
    );

    add(
      'popIn',
      const ScaleStyle(
        begin: 0.0,
        end: 1.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        isScaled: true,
      ),
    );

    add(
      'shrinkOut',
      const ScaleStyle(
        begin: 1.0,
        end: 0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInBack,
        isScaled: true,
      ),
    );
  }

  static void register(Object name, ScaleStyle style) => instance.add(name, style);

  static ScaleStyle? of(Object name) => instance.get(name);
}
