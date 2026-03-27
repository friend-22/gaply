import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'translate_style.dart';

class GaplyTranslatePreset with GaplyPreset<TranslateStyle> {
  static final GaplyTranslatePreset instance = GaplyTranslatePreset._internal();

  GaplyTranslatePreset._internal() {
    _initDefaultPresets();
  }

  void _initDefaultPresets() {
    add(
      'push',
      const TranslateStyle(
        begin: Offset.zero,
        end: Offset(0, 2),
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOutQuad,
        isMoved: true,
      ),
    );

    add(
      'float',
      const TranslateStyle(
        begin: Offset.zero,
        end: Offset(0, -4),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        isMoved: true,
      ),
    );

    add(
      'nudge',
      const TranslateStyle(
        begin: Offset.zero,
        end: Offset(6, 0),
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        isMoved: true,
      ),
    );

    add(
      'rise',
      const TranslateStyle(
        begin: Offset(0, 10),
        end: Offset.zero,
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        isMoved: true,
      ),
    );
  }

  static void register(String name, TranslateStyle style) => instance.add(name, style);

  static TranslateStyle? of(String name) => instance.get(name);
}
