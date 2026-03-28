import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/styles.dart';

import 'box_style.dart';

class GaplyBoxPreset with GaplyPreset<BoxStyle> {
  static final GaplyBoxPreset instance = GaplyBoxPreset._internal();

  GaplyBoxPreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add('rainbow', BoxStyle(gradient: GaplyGradient.preset('rainbow')));

    add(
      'card',
      const BoxStyle(
        layout: GaplyLayout(padding: EdgeInsets.all(16), borderRadius: BorderRadius.all(Radius.circular(12))),
        color: GaplyColor(token: GaplyColorToken.surface),
      ),
    );

    add(
      'button',
      const BoxStyle(
        layout: GaplyLayout(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: GaplyColor(token: GaplyColorToken.primary),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  static void register(Object name, BoxStyle style) => instance.add(name, style);

  static BoxStyle? of(Object name) => instance.get(name);
}
