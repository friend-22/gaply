import 'package:flutter/widgets.dart';

import 'gaply_blur.dart';

extension GaplyBlurExtension on Widget {
  Widget withBlur(BuildContext context, GaplyBlur style, {BorderRadiusGeometry? borderRadius}) {
    return style.buildWidget(context: context, borderRadius: borderRadius, child: this);
  }
}
