import 'package:flutter/material.dart';

import 'gaply_reveal.dart';

extension GaplyRevealExtension on Widget {
  Widget withReveal(GaplyReveal style) => style.buildWidget(child: this);
}
