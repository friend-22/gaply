import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/animation_params.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/scale_widget.dart';

@immutable
class ScaleParams extends AnimationParams {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const ScaleParams({
    super.duration,
    super.curve,
    super.onComplete,
    required this.begin,
    required this.end,
    this.alignment = Alignment.center,
    required this.isScaled,
  });

  const ScaleParams.none()
    : this(
        duration: Duration.zero,
        curve: Curves.linear,
        begin: 0.0,
        end: 1.0,
        alignment: Alignment.center,
        isScaled: false,
      );

  factory ScaleParams.preset(String name, {Alignment? alignment, bool? isScaled}) {
    final params = GaplyScalePreset.of(name);

    if (params == null) {
      throw ArgumentError('Unknown scale preset: "$name"');
    }

    return alignment != null || isScaled != null
        ? params.copyWith(alignment: alignment, isScaled: isScaled)
        : params;
  }

  @override
  bool get isEnabled => isScaled && duration.inMilliseconds > 0;

  ScaleParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
  }

  @override
  ScaleParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isScaled,
  }) {
    return ScaleParams(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alignment: alignment ?? this.alignment,
      isScaled: isScaled ?? this.isScaled,
    );
  }

  @override
  ScaleParams lerp(AnimationParams? other, double t) {
    if (other is! ScaleParams) return this;

    return ScaleParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      begin: lerpDouble(begin, other.begin, t) ?? begin,
      end: lerpDouble(end, other.end, t) ?? end,
      alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
      isScaled: t < 0.5 ? isScaled : other.isScaled,
    );
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isScaled];

  Widget buildWidget({required Widget child}) {
    return ScaleTrigger(params: this, trigger: DateTime.now(), child: child);
  }
}

extension ScaleParamsExtension on Widget {
  Widget withScale(ScaleParams params) => ScaleTrigger(params: params, trigger: DateTime.now(), child: this);
}

class GaplyScalePreset with GaplyPreset<ScaleParams> {
  static final GaplyScalePreset instance = GaplyScalePreset._internal();
  GaplyScalePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'pop',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        begin: 0.0,
        end: 1.1,
        isScaled: true,
      ),
    );
    add(
      'shrink',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        begin: 1.0,
        end: 0.0,
        isScaled: true,
      ),
    );
    add(
      'grow',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        begin: 0.0,
        end: 1.0,
        isScaled: true,
      ),
    );
  }

  static void register(String name, ScaleParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static ScaleParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
