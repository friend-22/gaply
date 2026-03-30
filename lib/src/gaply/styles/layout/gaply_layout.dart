import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';

import 'layout_preset.dart';
import 'layout_style_modifier.dart';

part 'gaply_layout.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyLayout extends GaplyStyle<GaplyLayout> with _GaplyLayoutMixin, LayoutStyleModifier<GaplyLayout> {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final double scale;
  final double borderWidth;

  const GaplyLayout({
    super.profiler,
    this.padding,
    this.margin,
    this.borderRadius,
    this.alignment,
    this.width,
    this.height,
    this.scale = 1.0,
    this.borderWidth = 0.0,
  });

  const GaplyLayout.none()
    : padding = EdgeInsets.zero,
      margin = EdgeInsets.zero,
      borderRadius = BorderRadius.zero,
      alignment = Alignment.center,
      scale = 1.0,
      borderWidth = 0.0,
      width = null,
      height = null;

  // static void register(Object key, GaplyLayout style) => GaplyLayoutPreset.add(key, style);
  //
  // factory GaplyLayout.preset(Object key, {GaplyProfiler? profiler}) {
  //   final style = GaplyLayoutPreset.of(key);
  //   if (style == null) {
  //     throw ArgumentError(GaplyLayoutPreset.error("GaplyLayout", key));
  //   }
  //   return style.copyWith(profiler: profiler);
  // }

  @override
  GaplyLayout copyWith({
    GaplyProfiler? profiler,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
    double? width,
    double? height,
    double? scale,
    double? borderWidth,
  }) {
    return GaplyLayout(
      profiler: profiler ?? this.profiler,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      height: height ?? this.height,
      scale: scale ?? this.scale,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  GaplyLayout lerp(GaplyLayout? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyLayout(
        profiler: other.profiler,
        padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
        margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
        alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
        width: lerpDouble(width, other.width, t),
        height: lerpDouble(height, other.height, t),
        scale: lerpDouble(scale, other.scale, t) ?? scale,
        borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [padding, margin, borderRadius, alignment, width, height, scale, borderWidth];

  @override
  bool get hasEffect => true;
}

mixin _GaplyLayoutMixin {
  GaplyLayout get _self => this as GaplyLayout;
  GaplyLayout get layoutStyle => this as GaplyLayout;

  GaplyLayout copyWithLayout(GaplyLayout layout) {
    return _self.copyWith(
      profiler: layout.profiler,
      padding: layout.padding,
      margin: layout.margin,
      borderRadius: layout.borderRadius,
      alignment: layout.alignment,
      width: layout.width,
      height: layout.height,
      scale: layout.scale,
      borderWidth: layout.borderWidth,
    );
  }
}
