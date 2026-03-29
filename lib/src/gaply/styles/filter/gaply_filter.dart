import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';

import 'filter_presets.dart';
import 'filter_style_modifier.dart';

part 'filter_widget.dart';

@immutable
class GaplyFilter extends GaplyStyle<GaplyFilter> with _GaplyFilterMixin, FilterStyleModifier<GaplyFilter> {
  final double grayscale; // 0.0 ~ 1.0
  final double contrast; // 1.0 (기본) ~ 2.0
  final double brightness; // 0.0 (기본) ~ 1.0
  final GaplyColor blendColor;
  final BlendMode blendMode;

  const GaplyFilter({
    super.profiler,
    this.grayscale = 0.0,
    this.contrast = 1.0,
    this.brightness = 0.0,
    this.blendColor = const GaplyColor.none(),
    this.blendMode = BlendMode.srcOver,
  });

  const GaplyFilter.none() : this();

  static void register(Object name, GaplyFilter style) => GaplyFilterPreset.register(name, style);

  factory GaplyFilter.preset(Object name, {GaplyProfiler? profiler}) {
    final style = GaplyFilterPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyFilterPreset.instance.errorMessage("GaplyFilter", name));
    }
    return style.copyWith(profiler: profiler);
  }

  @override
  GaplyFilter lerp(GaplyFilter? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      return GaplyFilter(
        grayscale: lerpDouble(grayscale, other.grayscale, t) ?? grayscale,
        contrast: lerpDouble(contrast, other.contrast, t) ?? contrast,
        brightness: lerpDouble(brightness, other.brightness, t) ?? brightness,
        blendColor: blendColor.lerp(other.blendColor, t),
        blendMode: t < 0.5 ? blendMode : other.blendMode,
      );
    }, tag: 'lerp');
  }

  @override
  GaplyFilter copyWith({
    GaplyProfiler? profiler,
    double? grayscale,
    double? contrast,
    double? brightness,
    GaplyColor? blendColor,
    BlendMode? blendMode,
  }) {
    return GaplyFilter(
      profiler: profiler ?? this.profiler,
      grayscale: grayscale ?? this.grayscale,
      contrast: contrast ?? this.contrast,
      brightness: brightness ?? this.brightness,
      blendColor: blendColor ?? this.blendColor,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  bool get hasEffect => grayscale != 0.0 || contrast != 1.0 || brightness != 0.0 || blendColor.hasEffect;

  @override
  List<Object?> get props => [grayscale, contrast, brightness, blendColor, blendMode];
}

mixin _GaplyFilterMixin {
  GaplyFilter get _self => this as GaplyFilter;
  GaplyFilter get filterStyle => _self;

  GaplyFilter copyWithFilter(GaplyFilter filter) {
    return _self.copyWith(
      profiler: filter.profiler,
      grayscale: filter.grayscale,
      contrast: filter.contrast,
      brightness: filter.brightness,
      blendColor: filter.blendColor,
      blendMode: filter.blendMode,
    );
  }

  Widget buildWidget({required BuildContext context, required Widget child}) {
    if (!_self.hasEffect) return child;

    return _FilterWidget(style: _self, child: child);
  }

  ColorFilter? resolve(BuildContext context) {
    if (!_self.hasEffect) return null;

    return _self.profiler.trace(() {
      final resolvedColor = _self.blendColor.resolve(context);

      if (resolvedColor != null) {
        return ColorFilter.mode(resolvedColor, _self.blendMode);
      }

      final double s = 1 - _self.grayscale;
      final double r = 0.2126 * _self.grayscale;
      final double g = 0.7152 * _self.grayscale;
      final double b = 0.0722 * _self.grayscale;
      final double c = _self.contrast;
      final double br = _self.brightness * 255;

      return ColorFilter.matrix(<double>[
        (r + s) * c,
        g * c,
        b * c,
        0,
        br,
        r * c,
        (g + s) * c,
        b * c,
        0,
        br,
        r * c,
        g * c,
        (b + s) * c,
        0,
        br,
        0,
        0,
        0,
        1,
        0,
      ]);
    }, tag: 'resolve');
  }
}
