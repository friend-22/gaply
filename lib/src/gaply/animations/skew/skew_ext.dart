import 'package:flutter/widgets.dart';

import 'skew_style.dart';

extension GaplySkewExtension on Widget {
  Widget withSlide(SkewStyle style) => style.buildWidget(child: this);
}
