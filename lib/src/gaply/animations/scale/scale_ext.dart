import 'package:flutter/material.dart';

import 'gaply_scale.dart';

extension GaplyScaleExtension on Widget {
  Widget withScale(GaplyScale style) => style.buildWidget(child: this);
}
