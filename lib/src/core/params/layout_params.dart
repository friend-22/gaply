import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/gaply.dart';

@immutable
class LayoutParams extends ParamsBase<LayoutParams> {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;

  const LayoutParams({this.padding, this.margin, this.borderRadius, this.alignment, this.width, this.height});

  const LayoutParams.none()
    : padding = EdgeInsets.zero,
      margin = EdgeInsets.zero,
      borderRadius = BorderRadius.zero,
      alignment = Alignment.center,
      width = null,
      height = null;

  factory LayoutParams.preset(String name) {
    final params = GaplyLayoutPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown box preset: "$name"');
    }
    return params;
  }

  // LayoutParams boxSize(double width, double height) {
  //   return copyWith(width: width, height: height);
  // }
  //
  // LayoutParams padding(EdgeInsetsGeometry padding) {
  //   return copyWith(padding: padding);
  // }
  //
  // LayoutParams margin(EdgeInsetsGeometry margin) {
  //   return copyWith(margin: margin);
  // }
  //
  // LayoutParams borderRadius(BorderRadiusGeometry borderRadius) {
  //   return copyWith(borderRadius: borderRadius);
  // }
  //
  // LayoutParams alignment(AlignmentGeometry alignment) {
  //   return copyWith(alignment: alignment);
  // }

  @override
  LayoutParams copyWith({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    AlignmentGeometry? alignment,
    double? width,
    double? height,
  }) {
    return LayoutParams(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool get isEnabled => true;

  @override
  LayoutParams lerp(LayoutParams? other, double t) {
    if (other == null) return this;

    return LayoutParams(
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      borderRadius: BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
    );
  }

  @override
  List<Object?> get props => [padding, margin, borderRadius, alignment, width, height];
}

class GaplyLayoutPreset with GaplyPreset<LayoutParams> {
  static final GaplyLayoutPreset instance = GaplyLayoutPreset._internal();
  GaplyLayoutPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
  }

  static void register(String name, LayoutParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static LayoutParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
