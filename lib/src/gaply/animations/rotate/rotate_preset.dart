import 'package:flutter/animation.dart';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'rotate_style.dart';

part 'rotate_preset.g.dart';

@gaplyPreset
class RotatePreset extends GaplyPreset<RotateStyle> {
  static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;

  @override
  GaplyPresetPolicy get presetPolicy => policy;

  RotatePreset._internal() {
    _initDefaultPreset();
  }

  void _initDefaultPreset() {
    GaplyRotatePreset.add(
      'tiltRight',
      const RotateStyle(
        begin: 0,
        end: 5,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        isRotated: true,
      ),
    );

    GaplyRotatePreset.add(
      'tiltLeft',
      const RotateStyle(
        begin: 0,
        end: -5,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        isRotated: true,
      ),
    );

    GaplyRotatePreset.add('flip', const RotateStyle(begin: 0, end: 180, isRotated: true));

    GaplyRotatePreset.add('slight', const RotateStyle(begin: -2, end: 2, isRotated: true));
  }
}
