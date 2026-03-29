import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'reveal_style.dart';

part 'reveal_preset.g.dart';

@gaplyPreset
class RevealPreset extends GaplyPreset<RevealStyle> {
  static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;

  @override
  GaplyPresetPolicy get presetPolicy => policy;

  RevealPreset._internal() {
    _initDefaultPreset();
  }

  void _initDefaultPreset() {
    GaplyRevealPreset.add(
      'drop',
      const RevealStyle(direction: AxisDirection.down, isVisible: true, useFade: true, fixedSize: false),
    );

    GaplyRevealPreset.add(
      'rise',
      const RevealStyle(direction: AxisDirection.up, isVisible: true, useFade: true, fixedSize: false),
    );

    GaplyRevealPreset.add(
      'expandRight',
      const RevealStyle(direction: AxisDirection.right, isVisible: true, useFade: true, fixedSize: false),
    );

    GaplyRevealPreset.add(
      'fadeIn',
      const RevealStyle(
        direction: AxisDirection.down,
        isVisible: true,
        useFade: true,
        fixedSize: true,
        duration: Duration(milliseconds: 300),
      ),
    );

    GaplyRevealPreset.add(
      'bounce',
      const RevealStyle(
        direction: AxisDirection.up,
        isVisible: true,
        useFade: true,
        fixedSize: false,
        curve: Curves.elasticOut,
        duration: Duration(milliseconds: 600),
      ),
    );
  }
}
