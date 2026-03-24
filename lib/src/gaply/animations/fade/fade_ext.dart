import 'package:flutter/material.dart';

import 'fade_style.dart';

extension GaplyFadeX on FadeStyle {}

extension GaplyFadeExtension on Widget {
  Widget withFade(FadeStyle style) => style.buildWidget(child: this);
}
