import 'package:flutter/material.dart';

import 'gaply_fade.dart';
import 'fade_widget.dart';

extension GaplyFadeX on GaplyFade {}

/// Extension to easily wrap any [Widget] with a fade animation.
extension GaplyFadeExtension on Widget {
  /// Wraps this widget with a [GaplyFadeWidget] using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Fading Text").withFade(
  ///   GaplyFade(
  ///     visible: _isVisible,
  ///     duration: Duration(seconds: 1),
  ///   ),
  /// )
  /// ```
  Widget withFade(GaplyFade style) => style.buildWidget(child: this);
}
