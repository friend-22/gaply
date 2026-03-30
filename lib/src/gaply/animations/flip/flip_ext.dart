import 'package:flutter/material.dart';

import 'flip_style.dart';
import 'flip_widget.dart';

extension GaplyFlipX on GaplyFlipStyle {}

extension GaplyFlipExtension on Widget {
  /// Wraps the widget with a [GaplyFlip] animation.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Image.asset('assets/card_front.png').withFlip(
  ///   GaplyFlipStyle(
  ///     axis: Axis.horizontal,
  ///     isFlipped: _isCardFlipped,
  ///     duration: const Duration(milliseconds: 500),
  ///   ),
  ///   back: Image.asset('assets/card_back.png'),
  /// )
  /// ```
  Widget withFlip(GaplyFlipStyle style, {Widget? back}) {
    if (back == null) {
      return style.buildWidget(child: this);
    }

    return style.copyWith(backWidget: back).buildWidget(child: this);
  }
}
