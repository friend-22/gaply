import 'package:flutter/widgets.dart';

import 'gaply_skew.dart';
import 'skew_widget.dart';

/// Extension to easily wrap any [Widget] with a skew animation.
///
/// [GaplySkew] applies a skew transformation to a widget.
extension GaplySkewExtension on Widget {
  /// Wraps this widget with a [SkewWidget] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Text("Skewed Text").withSkew(
  ///   GaplySkew.horizontal(0.2, duration: Duration(milliseconds: 500)),
  /// )
  /// ```
  Widget withSlide(GaplySkew style) => style.buildWidget(child: this);
}
