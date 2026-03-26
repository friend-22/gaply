import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/styles.dart';

import 'text_style.dart';

class GaplyTextPreset with GaplyPreset<GaplyTextStyle> {
  static final GaplyTextPreset instance = GaplyTextPreset._internal();
  GaplyTextPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, GaplyTextStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyTextStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
