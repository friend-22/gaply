import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/flip_widget.dart';
import '../base/animation_params.dart';

@immutable
class FlipParams extends AnimationParams {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;

  const FlipParams({
    super.duration,
    super.curve = Curves.fastOutSlowIn,
    super.onComplete,
    this.axis = Axis.vertical,
    this.angleRange = math.pi,
    this.isFlipped = false,
  });

  factory FlipParams.preset(String name, {bool? isFlipped}) {
    final params = GaplyFlipPreset.of(name) ?? GaplyFlipPreset.of('none')!;
    return params.copyWith(isFlipped: isFlipped);
  }

  factory FlipParams.fast(String name, {bool? isFlipped}) {
    final params = GaplyFlipPreset.of(name) ?? GaplyFlipPreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 300), isFlipped: isFlipped);
  }

  factory FlipParams.slow(String name, {bool? isFlipped}) {
    final params = GaplyFlipPreset.of(name) ?? GaplyFlipPreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 800), isFlipped: isFlipped);
  }

  factory FlipParams.elastic({
    Duration duration = const Duration(milliseconds: 400),
    Axis axis = Axis.horizontal,
    bool isFlipped = false,
  }) {
    return FlipParams(duration: duration, curve: Curves.elasticOut, axis: axis, isFlipped: isFlipped);
  }

  factory FlipParams.bounce({
    Duration duration = const Duration(milliseconds: 500),
    Axis axis = Axis.horizontal,
    bool isFlipped = false,
  }) {
    return FlipParams(duration: duration, curve: Curves.bounceOut, axis: axis, isFlipped: isFlipped);
  }

  @override
  FlipParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Axis? axis,
    double? angleRange,
    bool? isFlipped,
  }) {
    return FlipParams(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      axis: axis ?? this.axis,
      angleRange: angleRange ?? this.angleRange,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  FlipParams lerp(AnimationParams? other, double t) {
    if (other is! FlipParams) return this;
    return FlipParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      axis: t < 0.5 ? axis : other.axis,
      angleRange: lerpDouble(angleRange, other.angleRange, t) ?? angleRange,
      isFlipped: t < 0.5 ? isFlipped : other.isFlipped,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, angleRange, isFlipped];

  Widget buildWidget({required Widget front, required Widget back}) {
    return FlipWidget(front: front, back: back, flipParams: this);
  }
}

extension FlipParamsExtension on Widget {
  Widget withFlip(FlipParams flipParams, {required Widget back}) {
    return FlipWidget(front: this, back: back, flipParams: flipParams);
  }
}

class GaplyFlipPreset with GaplyPreset<FlipParams> {
  static final GaplyFlipPreset instance = GaplyFlipPreset._internal();

  GaplyFlipPreset._internal() {
    register('none', const FlipParams(duration: Duration.zero));
    register('vertical', const FlipParams(axis: Axis.vertical));
    register('horizontal', const FlipParams(axis: Axis.horizontal));
  }

  static void register(String name, FlipParams params) => instance.add(name, params);

  static FlipParams? of(String name) => instance.get(name);
}
