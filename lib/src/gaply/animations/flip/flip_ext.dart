import 'package:flutter/material.dart';

import 'flip_style.dart';

extension GaplyFlipX on FlipStyle {}

extension GaplyFlipExtension on Widget {
  Widget withFlip(FlipStyle style, {Widget? back}) {
    if (back == null) {
      return style.buildWidget(child: this);
    }

    return style.copyWith(backWidget: back).buildWidget(child: this);
  }
}
