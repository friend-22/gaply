import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/effects/color/color_defines.dart';
import 'package:gaply/src/gaply/effects/color/gaply_color.dart';

import 'gaply_gradient_modifier.dart';

part 'gaply_gradient.preset.g.dart';

enum GradientType { linear, radial, sweep }

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyGradient extends GaplyStyle<GaplyGradient>
    with _GaplyGradientMixin, GaplyGradientModifier<GaplyGradient> {
  final GradientType type;
  final List<GaplyColor> colors;
  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double startAngle;
  final double endAngle;

  const GaplyGradient({
    super.profiler,
    this.type = GradientType.linear,
    required this.colors,
    required this.stops,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.startAngle = 0.0,
    this.endAngle = 2 * math.pi,
  });

  const GaplyGradient.none() : this(type: GradientType.linear, colors: const [], stops: const []);

  static GaplyGradientPreset preset = GaplyGradientPreset._i;

  factory GaplyGradient.of(Object key, {GaplyProfiler? profiler, GradientType? type}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, type: type);
  }

  @override
  GaplyGradient copyWith({
    GaplyProfiler? profiler,
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
      profiler: profiler ?? this.profiler,
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

    return profiler.trace(() {
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
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [type, colors, stops, begin, end, startAngle, endAngle];

  @override
  bool get hasEffect => colors.isNotEmpty && stops.isNotEmpty;
}

mixin _GaplyGradientMixin {
  GaplyGradient get _self => this as GaplyGradient;
  GaplyGradient get gaplyGradient => _self;

  GaplyGradient copyWithGradient(GaplyGradient gradient) {
    return _self.copyWith(
      profiler: gradient.profiler,
      type: gradient.type,
      colors: gradient.colors,
      stops: gradient.stops,
      begin: gradient.begin,
      end: gradient.end,
      startAngle: gradient.startAngle,
      endAngle: gradient.endAngle,
    );
  }

  Gradient? resolve(BuildContext context) {
    if (!_self.hasEffect) return null;

    return _self.profiler.trace(() {
      final resolvedColors = _self.colors.map((p) => p.resolve(context)).whereType<Color>().toList();

      if (resolvedColors.length != _self.colors.length) {
        return null;
      }

      return switch (_self.type) {
        GradientType.linear => LinearGradient(
          colors: resolvedColors,
          stops: _self.stops,
          begin: _self.begin,
          end: _self.end,
        ),
        GradientType.radial => RadialGradient(colors: resolvedColors, stops: _self.stops),
        GradientType.sweep => SweepGradient(
          colors: resolvedColors,
          stops: _self.stops,
          startAngle: _self.startAngle,
          endAngle: _self.endAngle,
        ),
      };
    }, tag: 'resolve');
  }
}

void _initPresets(GaplyGradientPreset preset) {
  preset.add(
    'sunset',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor(token: GaplyColorToken.error),
        GaplyColor(token: GaplyColorToken.warning),
      ],
      stops: [0.0, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  preset.add(
    'ocean',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor(token: GaplyColorToken.primary),
        GaplyColor(token: GaplyColorToken.secondary),
      ],
      stops: [0.0, 1.0],
    ),
  );

  preset.add(
    'forest',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor(token: GaplyColorToken.secondary, shade: GaplyColorShade.s300),
        GaplyColor(token: GaplyColorToken.secondary, shade: GaplyColorShade.s700),
      ],
      stops: [0.0, 1.0],
    ),
  );

  preset.add(
    'midnight',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s800),
        GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s400),
      ],
      stops: [0.0, 1.0],
    ),
  );

  preset.add(
    'rainbow',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor.fromColor(Colors.red),
        GaplyColor.fromColor(Colors.orange),
        GaplyColor.fromColor(Colors.yellow),
        GaplyColor.fromColor(Colors.green),
        GaplyColor.fromColor(Colors.blue),
        GaplyColor.fromColor(Colors.indigo),
        GaplyColor.fromColor(Colors.purple),
      ],
      stops: [0.0, 0.16, 0.33, 0.5, 0.67, 0.83, 1.0],
    ),
  );

  preset.add(
    'warm',
    const GaplyGradient(
      type: GradientType.radial,
      colors: [
        GaplyColor(token: GaplyColorToken.warning, shade: GaplyColorShade.s300),
        GaplyColor(token: GaplyColorToken.warning, shade: GaplyColorShade.s600),
      ],
      stops: [0.0, 1.0],
    ),
  );

  preset.add(
    'cool',
    const GaplyGradient(
      type: GradientType.linear,
      colors: [
        GaplyColor(token: GaplyColorToken.primary),
        GaplyColor(token: GaplyColorToken.primary, shade: GaplyColorShade.s700),
      ],
      stops: [0.0, 1.0],
    ),
  );
}
