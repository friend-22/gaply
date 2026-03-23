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
    super.curve,
    super.onComplete,
    required this.axis,
    this.angleRange = math.pi,
    required this.isFlipped,
  }) : assert(angleRange > 0 && angleRange <= 2 * math.pi, 'angleRange은 0~2π 범위여야 합니다');

  const FlipParams.none()
    : this(duration: Duration.zero, curve: Curves.linear, axis: Axis.horizontal, isFlipped: false);

  factory FlipParams.preset(String name, {bool? isFlipped}) {
    final params = GaplyFlipPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown flip preset: "$name"');
    }
    return isFlipped != null ? params.copyWith(isFlipped: isFlipped) : params;
  }

  FlipParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
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
    return FlipTrigger(front: front, back: back, trigger: DateTime.now(), params: this);
  }
}

extension FlipParamsX on FlipParams {
  FlipParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
  }
}

extension FlipParamsExtension on Widget {
  Widget withFlip(FlipParams flipParams, {required Widget back}) {
    return FlipTrigger(front: this, back: back, trigger: DateTime.now(), params: flipParams);
  }
}

class GaplyFlipPreset with GaplyPreset<FlipParams> {
  static final GaplyFlipPreset instance = GaplyFlipPreset._internal();
  GaplyFlipPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'vertical',
      const FlipParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        axis: Axis.vertical,
        isFlipped: true,
      ),
    );
    add(
      'horizontal',
      const FlipParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        axis: Axis.horizontal,
        isFlipped: true,
      ),
    );
  }

  static void register(String name, FlipParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static FlipParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
