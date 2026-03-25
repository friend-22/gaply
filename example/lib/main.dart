import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

import 'demo_animation.dart';

void main() {
  BoxStyle.register(
    'glassCard',
    const BoxStyle()
        .boxSize(340, 200)
        .boxPadding(const EdgeInsets.all(24))
        .boxRadius(BorderRadius.circular(24))
        .boxBorderWidth(1.5)
        .boxBorderColor(Colors.white.withValues(alpha: 0.2))
        .blurPreset('apple')
        .boxColorRole(ColorRole.surface, opacity: ColorOpacity.transparent)
        .boxElevation(12),
  );

  BoxStyle.register(
    'animCard',
    const BoxStyle()
        .boxSize(300, 300)
        .boxRadius(BorderRadius.circular(32))
        .boxPadding(const EdgeInsets.all(24))
        .boxColorRole(ColorRole.surface, opacity: ColorOpacity.transparent)
        .blurPreset('apple')
        .boxBorderWidth(1)
        .boxBorderColor(Colors.white.withValues(alpha: 0.1))
        .boxDuration(const Duration(milliseconds: 400))
        .boxCurve(Curves.easeOutBack),
  );

  runApp(const MaterialApp(home: GaplyAnimDemo()));
}
