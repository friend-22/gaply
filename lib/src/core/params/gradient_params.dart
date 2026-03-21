import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';

import 'color_params.dart';

enum GradientType { linear, radial, sweep }

@immutable
class GradientParams extends ParamsBase<GradientParams> with _GradientParamsMixin {
  final GradientType type;
  final List<ColorParams> colors;
  final List<double> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double startAngle;
  final double endAngle;

  const GradientParams({
    this.type = GradientType.linear,
    required this.colors,
    required this.stops,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.startAngle = 0.0,
    this.endAngle = 2 * math.pi,
  });

  factory GradientParams.preset(String name, {GradientType? type}) {
    final params = GaplyGradientPreset.of(name) ?? GaplyGradientPreset.of('none')!;
    return params.copyWith(type: type);
  }

  @override
  bool get isEnabled => colors.isNotEmpty;

  @override
  GradientParams copyWith({
    GradientType? type,
    List<ColorParams>? colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? startAngle,
    double? endAngle,
  }) {
    return GradientParams(
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
  GradientParams lerp(GradientParams? other, double t) {
    if (other == null) return this;

    final lerpColors = <ColorParams>[];
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

    return GradientParams(
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

mixin _GradientParamsMixin {
  GradientParams get _params => this as GradientParams;

  Gradient? resolve(BuildContext context) {
    if (!_params.isEnabled) return null;

    final colors = _params.colors.map((p) => p.resolve(context)).whereType<Color>().toList();
    if (colors.isEmpty) return null;

    return switch (_params.type) {
      GradientType.linear => LinearGradient(
        colors: colors,
        stops: _params.stops,
        begin: _params.begin,
        end: _params.end,
      ),
      GradientType.radial => RadialGradient(colors: colors, stops: _params.stops),
      GradientType.sweep => SweepGradient(
        colors: colors,
        stops: _params.stops,
        startAngle: _params.startAngle,
        endAngle: _params.endAngle,
      ),
    };
  }
}

extension GradientParamsExtension on BoxDecoration {
  // BoxDecoration withGradient(BuildContext context, GradientParams params) {
  //   return copyWith(gradient: params.resolve(context));
  // }
}

class GaplyGradientPreset with GaplyPreset<GradientParams> {
  static final GaplyGradientPreset instance = GaplyGradientPreset._internal();
  GaplyGradientPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const GradientParams(colors: [], stops: []));
    add(
      'sunset',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.error),
          ColorParams(role: ColorRole.warning),
        ],
        stops: [0.0, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
    add(
      'ocean',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.primary),
          ColorParams(role: ColorRole.secondary),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'forest',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.secondary, shade: ColorShade.s300),
          ColorParams(role: ColorRole.secondary, shade: ColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'midnight',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.primary, shade: ColorShade.s800),
          ColorParams(role: ColorRole.primary, shade: ColorShade.s400),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'rainbow',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.error),
          ColorParams(role: ColorRole.warning),
          ColorParams(role: ColorRole.secondary),
          ColorParams(role: ColorRole.primary),
        ],
        stops: [0.0, 0.33, 0.66, 1.0],
      ),
    );
    add(
      'warm',
      const GradientParams(
        type: GradientType.radial,
        colors: [
          ColorParams(role: ColorRole.warning, shade: ColorShade.s300),
          ColorParams(role: ColorRole.warning, shade: ColorShade.s600),
        ],
        stops: [0.0, 1.0],
      ),
    );
    add(
      'cool',
      const GradientParams(
        type: GradientType.linear,
        colors: [
          ColorParams(role: ColorRole.primary),
          ColorParams(role: ColorRole.primary, shade: ColorShade.s700),
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

  static void register(String name, GradientParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static GradientParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
