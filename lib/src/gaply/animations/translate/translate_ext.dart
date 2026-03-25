import 'package:flutter/widgets.dart';

import 'translate_style.dart';
import 'gaply_translate.dart';

/// Extension to easily wrap any [Widget] with a translate animation.
///
/// [TranslateStyle] animates the position of a widget by applying
/// an [Offset] translation.
extension GaplyTranslateExtension on Widget {
  /// Wraps this widget with a [GaplyTranslate] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Sliding Text").withTranslate(
  ///   TranslateStyle(
  ///     begin: Offset(100, 0),
  ///     end: Offset.zero,
  ///     isMoved: true,
  ///     duration: Duration(seconds: 1),
  ///   ),
  /// )
  /// ```
  Widget withTranslate(TranslateStyle style) => style.buildWidget(child: this);
}
