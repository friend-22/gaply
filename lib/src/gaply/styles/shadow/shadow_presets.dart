import 'dart:ui';

import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/gaply/styles/color/color_defines.dart';

import 'gaply_shadow.dart';

class GaplyShadowPreset with GaplyPreset<GaplyShadow> {
  static final GaplyShadowPreset instance = GaplyShadowPreset._internal();
  GaplyShadowPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    const blurColor = GaplyColor.fromToken(GaplyColorToken.shadow);

    add(
      'small',
      const GaplyShadow(spreadRadius: 0.0, blurRadius: 4.0, offset: Offset(0, 2), color: blurColor),
    );
    add(
      'medium',
      const GaplyShadow(spreadRadius: -1.0, blurRadius: 10.0, offset: Offset(0, 4), color: blurColor),
    );
    add(
      'large',
      const GaplyShadow(spreadRadius: -2.0, blurRadius: 24.0, offset: Offset(0, 10), color: blurColor),
    );
    add(
      'base',
      const GaplyShadow(spreadRadius: 0.0, blurRadius: 5.0, offset: Offset(3, 3), color: blurColor),
    );
  }

  static void register(String name, GaplyShadow style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyShadow? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
