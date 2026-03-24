import 'package:flutter/material.dart';

import 'reveal_style.dart';

extension GaplyRevealExtension on Widget {
  Widget withReveal(RevealStyle style) => style.buildWidget(child: this);
}
