// import 'package:flutter/material.dart';
//
// import 'package:gaply/src/gaply/core/gaply_defines.dart';
// import 'package:gaply/src/annotations.dart';
// import 'package:gaply/src/utils/gaply_logger.dart';
//
// import 'size_style.dart';
//
// part 'size_preset.g.dart';
//
// @gaplyPreset
// class SizePreset extends GaplyPreset<SizeStyle> {
//   static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;
//
//   @override
//   GaplyPresetPolicy get presetPolicy => policy;
//
//   SizePreset._internal() {
//     _initDefaultPreset();
//   }
//
//   void _addByDirection(Object name, AxisDirection dir, {Duration? duration, Curve? curve}) {
//     final bool isVertical = dir == AxisDirection.up || dir == AxisDirection.down;
//
//     final bool isReversed = dir == AxisDirection.up || dir == AxisDirection.left;
//     final double alignment = isReversed ? 1.0 : -1.0;
//
//     GaplySizePreset.add(
//       name,
//       SizeStyle(
//         duration: duration ?? const Duration(milliseconds: 400),
//         curve: curve ?? Curves.easeOutCubic,
//         axis: isVertical ? Axis.vertical : Axis.horizontal,
//         axisAlignment: alignment,
//         isExpanded: true,
//       ),
//     );
//   }
//
//   void _initDefaultPreset() {
//     _addByDirection(
//       'popIn',
//       AxisDirection.up,
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.elasticOut,
//     );
//
//     _addByDirection(
//       'softUp',
//       AxisDirection.up,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOutQuad,
//     );
//
//     GaplySizePreset.add(
//       'exitRight',
//       SizeStyle(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInCubic,
//         axis: Axis.horizontal,
//         axisAlignment: -1.0,
//         isExpanded: false,
//       ),
//     );
//   }
// }
