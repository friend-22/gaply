import 'package:flutter/widgets.dart';

import 'slide_style.dart';

extension GaplySlideExtension on Widget {
  Widget withSlide(SlideStyle style) => style.buildWidget(child: this);
}
