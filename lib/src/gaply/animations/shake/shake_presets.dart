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
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        distance: 4.0,
        count: 2.0,
        isVertical: false,
      ),
    );
    add(
      'normal',
      const ShakeStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 8.0,
        count: 4.0,
        isVertical: false,
      ),
    );
    add(
      'severe',
      const ShakeStyle(
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate,
        distance: 12.0,
        count: 7.0,
        isVertical: false,
      ),
    );
    add(
      'alert',
      const ShakeStyle(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 6.0,
        count: 7.0,
        isVertical: false,
      ),
    );
    add(
      'nod',
      const ShakeStyle(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        distance: 6.0,
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
