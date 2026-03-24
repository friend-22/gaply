import 'package:flutter/material.dart';

import 'fade_style.dart';

extension GaplyFadeX on FadeStyle {}

/// Extension to easily wrap any [Widget] with a fade animation.
extension GaplyFadeExtension on Widget {
  /// Wraps this widget with a [GaplyFade] using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Fading Text").withFade(
  ///   FadeStyle(
  ///     visible: _isVisible,
  ///     duration: Duration(seconds: 1),
  ///   ),
  /// )
  /// ```
  Widget withFade(FadeStyle style) => style.buildWidget(child: this);
}
