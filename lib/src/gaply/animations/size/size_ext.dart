import 'package:flutter/widgets.dart';

import 'size_style.dart';

/// Extension to easily wrap any [Widget] with a size animation.
///
/// [SizeStyle] animates the size of a widget using [SizeTransition].
extension GaplySizeExtension on Widget {
  /// Wraps this widget with a [GaplySize] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Container(width: 100, height: 100).withSize(
  ///   SizeStyle(
  ///     axis: Axis.vertical,
  ///     isExpanded: _isExpanded,
  ///     duration: Duration(milliseconds: 300),
  ///   ),
  /// )
  /// ```
  Widget withSize(SizeStyle style) => style.buildWidget(child: this);
}
