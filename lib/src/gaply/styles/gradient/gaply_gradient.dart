import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

import '../color/gaply_color.dart';
import 'gradient_presets.dart';

enum GradientType { linear, radial, sweep }

@immutable
class GaplyGradient extends GaplyStyle<GaplyGradient> with _GGradientMixin {
  final GradientType type;
  final List<GaplyColor> colors;
  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double startAngle;
  final double endAngle;

  const GaplyGradient({
    this.type = GradientType.linear,
    required this.colors,
    required this.stops,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.startAngle = 0.0,
    this.endAngle = 2 * math.pi,
  });

  const GaplyGradient.none() : this(type: GradientType.linear, colors: const [], stops: const []);

  factory GaplyGradient.preset(String name, {GradientType? type}) {
    final style = GaplyGradientPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown gradient preset: "$name"');
    }
    return type != null ? style.copyWith(type: type) : style;
  }

  @override
  bool get isEnabled => colors.isNotEmpty && stops.isNotEmpty;

  @override
  GaplyGradient copyWith({
    GradientType? type,
    List<GaplyColor>? colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? startAngle,
    double? endAngle,
  }) {
    final newColors = colors ?? this.colors;
    final newStops = stops ?? this.stops;

    if (newColors.isNotEmpty && newStops.isEmpty ||
        newColors.isEmpty && newStops.isNotEmpty ||
        newColors.length != newStops.length) {
      throw ArgumentError(
        'colors와 stops는 함께 비어있거나, 길이가 같아야 합니다. '
        'colors: ${newColors.length}, stops: ${newStops.length}',
      );
    }

    return GaplyGradient(
      type: type ?? this.type,
      colors: colors ?? this.colors,
      stops: stops ?? this.stops,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
    );
  }

  @override
  GaplyGradient lerp(GaplyGradient? other, double t) {
    if (other == null) return this;

    final lerpColors = <GaplyColor>[];
    final maxLength = math.max(colors.length, other.colors.length);

    for (var i = 0; i < maxLength; i++) {
      final startColor = i < colors.length ? colors[i] : colors.last;
      final endColor = i < other.colors.length ? other.colors[i] : other.colors.last;

      lerpColors.add(startColor.lerp(endColor, t));
    }

    final lerpStops = <double>[];
    for (var i = 0; i < maxLength; i++) {
      final startStop = i < stops.length ? stops[i] : (i == 0 ? 0.0 : 1.0);
      final endStop = i < other.stops.length ? other.stops[i] : (i == 0 ? 0.0 : 1.0);

      lerpStops.add(lerpDouble(startStop, endStop, t) ?? startStop);
    }

    return GaplyGradient(
      type: t < 0.5 ? type : other.type,
      colors: lerpColors,
      stops: lerpStops,
      begin: AlignmentGeometry.lerp(begin, other.begin, t) ?? begin,
      end: AlignmentGeometry.lerp(end, other.end, t) ?? end,
      startAngle: lerpDouble(startAngle, other.startAngle, t) ?? startAngle,
      endAngle: lerpDouble(endAngle, other.endAngle, t) ?? endAngle,
    );
  }

  @override
  List<Object?> get props => [type, colors, stops, begin, end, startAngle, endAngle];
}

mixin _GGradientMixin {
  GaplyGradient get _params => this as GaplyGradient;

  Gradient? resolve(BuildContext context) {
    if (!_params.isEnabled) return null;

    final resolvedColors = _params.colors.map((p) => p.resolve(context)).whereType<Color>().toList();

    if (resolvedColors.length != _params.colors.length) {
      return null;
    }

    return switch (_params.type) {
      GradientType.linear => LinearGradient(
        colors: resolvedColors,
        stops: _params.stops,
        begin: _params.begin,
        end: _params.end,
      ),
      GradientType.radial => RadialGradient(colors: resolvedColors, stops: _params.stops),
      GradientType.sweep => SweepGradient(
        colors: resolvedColors,
        stops: _params.stops,
        startAngle: _params.startAngle,
        endAngle: _params.endAngle,
      ),
    };
  }
}
