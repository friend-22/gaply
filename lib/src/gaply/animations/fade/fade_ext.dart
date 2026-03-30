import 'package:flutter/material.dart';

import 'fade_style.dart';
import 'fade_widget.dart';

extension GaplyFadeX on GaplyFadeStyle {}

/// Extension to easily wrap any [Widget] with a fade animation.
extension GaplyFadeExtension on Widget {
  /// Wraps this widget with a [GaplyFade] using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Fading Text").withFade(
  ///   GaplyFadeStyle(
  ///     visible: _isVisible,
  ///     duration: Duration(seconds: 1),
  ///   ),
  /// )
  /// ```
  Widget withFade(GaplyFadeStyle style) => style.buildWidget(child: this);
}
