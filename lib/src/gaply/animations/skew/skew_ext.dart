import 'package:flutter/widgets.dart';

import 'skew_style.dart';

/// Extension to easily wrap any [Widget] with a skew animation.
///
/// [SkewStyle] applies a skew transformation to a widget.
extension GaplySkewExtension on Widget {
  /// Wraps this widget with a [GaplySkew] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Skewed Text").withSkew(
  ///   SkewStyle.horizontal(0.2, duration: Duration(milliseconds: 500)),
  /// )
  /// ```
  Widget withSlide(SkewStyle style) => style.buildWidget(child: this);
}
