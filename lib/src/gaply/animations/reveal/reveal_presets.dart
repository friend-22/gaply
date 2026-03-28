import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'reveal_style.dart';

class GaplyRevealPreset with GaplyPreset<RevealStyle> {
  static final GaplyRevealPreset instance = GaplyRevealPreset._internal();

  GaplyRevealPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'drop',
      const RevealStyle(direction: AxisDirection.down, isVisible: true, useFade: true, fixedSize: false),
    );

    add(
      'rise',
      const RevealStyle(direction: AxisDirection.up, isVisible: true, useFade: true, fixedSize: false),
    );

    add(
      'expandRight',
      const RevealStyle(direction: AxisDirection.right, isVisible: true, useFade: true, fixedSize: false),
    );

    add(
      'fadeIn',
      const RevealStyle(
        direction: AxisDirection.down,
        isVisible: true,
        useFade: true,
        fixedSize: true,
        duration: Duration(milliseconds: 300),
      ),
    );

    add(
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

  static void register(Object name, RevealStyle style) => instance.add(name, style);

  static RevealStyle? of(Object name) => instance.get(name);
}
