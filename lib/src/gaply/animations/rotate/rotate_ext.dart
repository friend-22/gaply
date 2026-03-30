import 'package:flutter/material.dart';

import 'gaply_rotate.dart';

extension GaplyRotateExtension on Widget {
  Widget withRotate(GaplyRotate style) => style.buildWidget(child: this);
}
