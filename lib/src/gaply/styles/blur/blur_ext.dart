import 'package:flutter/widgets.dart';

import 'blur_style.dart';

extension GaplyBlurExtension on Widget {
  Widget withBlur(BuildContext context, BlurStyle style, {BorderRadiusGeometry? borderRadius}) {
    return style.buildWidget(context: context, borderRadius: borderRadius, child: this);
  }
}
