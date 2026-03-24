import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'translate_style.dart';

class GaplyTranslatePreset with GaplyPreset<TranslateStyle> {
  static final GaplyTranslatePreset instance = GaplyTranslatePreset._internal();
  GaplyTranslatePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, TranslateStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static TranslateStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
