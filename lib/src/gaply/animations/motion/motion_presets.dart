import 'package:flutter/animation.dart';

import 'package:gaply/src/gaply/animations/fade/fade_style.dart';
import 'package:gaply/src/gaply/animations/scale/scale_style.dart';
import 'package:gaply/src/gaply/animations/shake/shake_style.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'gaply_motion.dart';

class GaplyMotionPreset with GaplyPreset<GaplyMotion> {
  static final GaplyMotionPreset instance = GaplyMotionPreset._internal();
  GaplyMotionPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'error',
      GaplyMotion(
        animations: [ShakeStyle.preset('severe'), FadeStyle.preset('fadeIn').copyWith(visible: false)],
      ),
    );
    add('success', GaplyMotion(animations: [ScaleStyle.preset('pop'), ShakeStyle.preset('nod')]));
    add('attention', GaplyMotion(animations: [FadeStyle.preset('fadeIn'), ShakeStyle.preset('mild')]));
    add(
      'critical',
      GaplyMotion(
        animations: [
          ShakeStyle.preset('alert'),
          ScaleStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            begin: 1.0,
            end: 1.05,
            isScaled: true,
          ),
        ],
      ),
    );
    add(
      'entrance',
      GaplyMotion(
        animations: [
          FadeStyle.preset('fadeIn'),
          ScaleStyle(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            begin: 0.9,
            end: 1.0,
            isScaled: true,
          ),
        ],
      ),
    );
    add(
      'exit',
      GaplyMotion(
        animations: [
          ScaleStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInBack,
            begin: 1.0,
            end: 0.9,
            isScaled: true,
          ),
          FadeStyle.preset('fadeOut'),
        ],
      ),
    );
  }

  static void register(String name, GaplyMotion style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static GaplyMotion? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
