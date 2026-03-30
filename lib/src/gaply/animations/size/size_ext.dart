import 'package:flutter/widgets.dart';

import 'gaply_size.dart';
import 'size_widget.dart';

/// Extension to easily wrap any [Widget] with a size animation.
///
/// [GaplySize] animates the size of a widget using [SizeTransition].
extension GaplySizeExtension on Widget {
  /// Wraps this widget with a [GaplySizeWidget] animation using the provided [style].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// Container(width: 100, height: 100).withSize(
  ///   GaplySize(
  ///     axis: Axis.vertical,
  ///     isExpanded: _isExpanded,
  ///     duration: Duration(milliseconds: 300),
  ///   ),
  /// )
  /// ```
  Widget withSize(GaplySize style) => style.buildWidget(child: this);
}
