import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

import 'demo_animation.dart';

void main() {
  BoxStyle.register(
    'glassCard',
    const BoxStyle()
        .layoutSize(340, 200)
        .layoutPadding(const EdgeInsets.all(24))
        .layoutRadius(24)
        .layoutBorderWidth(1.5)
        .borderColorCustom(Colors.white.withValues(alpha: 0.2))
        .blurPreset('apple')
        .colorToken(GaplyColorToken.surface, opacity: GaplyColorOpacity.transparent.value)
        .shadowElevation(12),
  );

  BoxStyle.register(
    'animCard',
    const BoxStyle()
        .layoutSize(300, 300)
        .layoutRadius(32)
        .layoutPadding(const EdgeInsets.all(24))
        .layoutBorderWidth(1)
        .colorToken(GaplyColorToken.surface, opacity: GaplyColorOpacity.transparent.value)
        .blurPreset('apple')
        .borderColorCustom(Colors.white.withValues(alpha: 0.1))
        .boxDuration(const Duration(milliseconds: 400))
        .boxCurve(Curves.easeOutBack),
  );

  runApp(const MaterialApp(home: GaplyAnimDemo()));
}
