import 'package:flutter/widgets.dart';

import 'shake_style.dart';

extension GaplyShakeExtension on Widget {
  Widget withShake(ShakeStyle style) => style.buildWidget(child: this);
}
