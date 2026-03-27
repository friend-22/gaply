import 'package:flutter/animation.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'rotate_style.dart';

class GaplyRotatePreset with GaplyPreset<RotateStyle> {
  static final GaplyRotatePreset instance = GaplyRotatePreset._internal();

  GaplyRotatePreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'tiltRight',
      const RotateStyle(
        begin: 0,
        end: 5,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        isRotated: true,
      ),
    );

    add(
      'tiltLeft',
      const RotateStyle(
        begin: 0,
        end: -5,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        isRotated: true,
      ),
    );

    add('flip', const RotateStyle(begin: 0, end: 180, isRotated: true));

    add('slight', const RotateStyle(begin: -2, end: 2, isRotated: true));
  }

  static void register(String name, RotateStyle style) => instance.add(name, style);

  static RotateStyle? of(String name) => instance.get(name);
}
