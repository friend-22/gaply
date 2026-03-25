import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'layout_presets.dart';
import 'layout_style_modifier.dart';

@immutable
class GaplyLayout extends GaplyStyle<GaplyLayout> with _GaplyLayoutMixin, LayoutStyleModifier<GaplyLayout> {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final double scale;

  const GaplyLayout({
    this.padding,
    this.margin,
    this.borderRadius,
    this.alignment,
    this.width,
    this.height,
    this.scale = 1.0,
  });

  const GaplyLayout.none()
    : padding = EdgeInsets.zero,
      margin = EdgeInsets.zero,
      borderRadius = BorderRadius.zero,
      alignment = Alignment.center,
      scale = 1.0,
      width = null,
      height = null;

  static void register(String name, GaplyLayout style) => GaplyLayoutPreset.register(name, style);

  factory GaplyLayout.preset(String name) {
    final style = GaplyLayoutPreset.of(name);

    if (style == null) {
      throw ArgumentError(
        'Unknown layout preset: "$name". '
        'Available presets: ${GaplyLayoutPreset.instance.allKeys.join(", ")}',
      );
    }

    return style;
  }

  @override
  GaplyLayout copyWith({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
    double? width,
    double? height,
    double? scale,
  }) {
    return GaplyLayout(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      height: height ?? this.height,
      scale: scale ?? this.scale,
    );
  }

  @override
  GaplyLayout lerp(GaplyLayout? other, double t) {
    if (other == null) return this;

    return GaplyLayout(
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      borderRadius: BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      scale: lerpDouble(scale, other.scale, t) ?? scale,
    );
  }

  @override
  List<Object?> get props => [padding, margin, borderRadius, alignment, width, height, scale];

  @override
  bool get hasEffect => true;
}

mixin _GaplyLayoutMixin {
  GaplyLayout get layoutStyle => this as GaplyLayout;

  GaplyLayout copyWithLayout(GaplyLayout layout) {
    return layoutStyle.copyWith(
      padding: layout.padding,
      margin: layout.margin,
      borderRadius: layout.borderRadius,
      alignment: layout.alignment,
      width: layout.width,
      height: layout.height,
      scale: layout.scale,
    );
  }
}
