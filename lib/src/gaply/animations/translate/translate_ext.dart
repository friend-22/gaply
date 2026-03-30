import 'package:flutter/widgets.dart';

import 'gaply_translate.dart';
import 'translate_widget.dart';

/// Extension to easily wrap any [Widget] with a translate animation.
///
/// [GaplyTranslate] animates the position of a widget by applying
/// an [Offset] translation.
extension GaplyTranslateExtension on Widget {
  /// Wraps this widget with a [GaplyTranslateWidget] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Sliding Text").withTranslate(
  ///   GaplyTranslate(
  ///     begin: Offset(100, 0),
  ///     end: Offset.zero,
  ///     isMoved: true,
  ///     duration: Duration(seconds: 1),
  ///   ),
  /// )
  /// ```
  Widget withTranslate(GaplyTranslate style) => style.buildWidget(child: this);
}
