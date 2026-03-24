import 'package:flutter/animation.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'shake_style.dart';

class GaplyShakePreset with GaplyPreset<ShakeStyle> {
  static final GaplyShakePreset instance = GaplyShakePreset._internal();
  GaplyShakePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'mild',
      const ShakeStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        distance: 3.0,
        count: 2.0,
      ),
    );

    add(
      'normal',
      const ShakeStyle(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
        distance: 6.0,
        count: 3.0,
      ),
    );

    add(
      'severe',
      const ShakeStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
        distance: 10.0,
        count: 5.0,
      ),
    );

    add(
      'alert',
      const ShakeStyle(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
        distance: 4.0,
        count: 6.0,
      ),
    );

    add(
      'nod',
      const ShakeStyle(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        distance: 5.0,
        count: 2.0,
        isVertical: true,
      ),
    );

    add(
      'celebrate',
      const ShakeStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 10.0,
        count: 3.0,
        isVertical: true,
      ),
    );
  }

  static void register(String name, ShakeStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static ShakeStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
