import 'package:flutter/widgets.dart';

import 'gaply_shake.dart';

extension GaplyShakeExtension on Widget {
  Widget withShake(GaplyShake style) => style.buildWidget(child: this);
}
