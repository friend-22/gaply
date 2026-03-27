import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'skew_style.dart';

class GaplySkewPreset with GaplyPreset<SkewStyle> {
  static final GaplySkewPreset instance = GaplySkewPreset._internal();
  GaplySkewPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add('tiltRight', SkewStyle.horizontal(0.1));

    add('tiltUp', SkewStyle.vertical(-0.1));

    add(
      'bounceSkew',
      SkewStyle.horizontal(0.2, duration: Duration(milliseconds: 600), curve: Curves.elasticOut),
    );

    add('flipPre', SkewStyle.horizontal(0.5, curve: Curves.easeInCubic));
  }

  static void register(String name, SkewStyle style) => instance.add(name, style);

  static SkewStyle? of(String name) => instance.get(name);
}
