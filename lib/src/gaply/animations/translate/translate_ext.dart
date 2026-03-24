import 'package:flutter/widgets.dart';

import 'translate_style.dart';

extension GaplyTranslateExtension on Widget {
  Widget withSlide(TranslateStyle style) => style.buildWidget(child: this);
}
