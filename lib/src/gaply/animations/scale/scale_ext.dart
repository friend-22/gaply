import 'package:flutter/material.dart';

import 'scale_style.dart';

extension GaplyScaleExtension on Widget {
  Widget withScale(ScaleStyle style) => style.buildWidget(child: this);
}
