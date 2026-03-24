import 'package:flutter/widgets.dart';

import 'size_style.dart';

extension GaplySizeExtension on Widget {
  Widget withSlide(SizeStyle style) => style.buildWidget(child: this);
}
