import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_preset.dart';

import 'size_style.dart';

class GaplySizePreset with GaplyPreset<SizeStyle> {
  static final GaplySizePreset instance = GaplySizePreset._internal();
  GaplySizePreset._internal();

  void _addByDirection(String name, AxisDirection dir, {Duration? duration, Curve? curve}) {
    final bool isVertical = dir == AxisDirection.up || dir == AxisDirection.down;

    final bool isReversed = dir == AxisDirection.up || dir == AxisDirection.left;
    final double alignment = isReversed ? 1.0 : -1.0;

    add(
      name,
      SizeStyle(
        duration: duration ?? const Duration(milliseconds: 400),
        curve: curve ?? Curves.easeOutCubic,
        axis: isVertical ? Axis.vertical : Axis.horizontal,
        axisAlignment: alignment,
        isExpanded: true,
      ),
    );
  }

  void _ensureInitialized() {
    if (hasPreset) return;

    _addByDirection(
      'popIn',
      AxisDirection.up,
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
    );

    _addByDirection(
      'softUp',
      AxisDirection.up,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );

    add(
      'exitRight',
      SizeStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInCubic,
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        isExpanded: false,
      ),
    );
  }

  static void register(String name, SizeStyle style) {
    instance._ensureInitialized();
    instance.add(name, style);
  }

  static SizeStyle? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
