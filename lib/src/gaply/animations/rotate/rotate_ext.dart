import 'package:flutter/material.dart';

import 'rotate_style.dart';

extension GaplyRotateExtension on Widget {
  Widget withRotate(RotateStyle style) => style.buildWidget(child: this);
}
