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
    super.curve = Curves.easeOutBack,
    super.onComplete,
    this.begin = 0.0,
    this.end = 1.0,
    this.alignment = Alignment.center,
    this.isScaled = false,
  });

  factory ScaleParams.preset(String name, {Alignment? alignment, bool? isScaled}) {
    final params = GaplyScalePreset.of(name) ?? GaplyScalePreset.of('none')!;
    return params.copyWith(alignment: alignment, isScaled: isScaled);
  }

  factory ScaleParams.fast(String name, {Alignment? alignment, bool? isScaled}) {
    final params = GaplyScalePreset.of(name) ?? GaplyScalePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 300), alignment: alignment, isScaled: isScaled);
  }

  factory ScaleParams.slow(String name, {Alignment? alignment, bool? isScaled}) {
    final params = GaplyScalePreset.of(name) ?? GaplyScalePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 800), alignment: alignment, isScaled: isScaled);
  }

  factory ScaleParams.elastic({
    Duration duration = const Duration(milliseconds: 400),
    Alignment alignment = Alignment.center,
    bool isScaled = false,
  }) {
    return ScaleParams(
      duration: duration,
      curve: Curves.elasticOut,
      alignment: alignment,
      isScaled: isScaled,
    );
  }

  factory ScaleParams.bounce({
    Duration duration = const Duration(milliseconds: 500),
    Alignment alignment = Alignment.center,
    bool isScaled = false,
  }) {
    return ScaleParams(duration: duration, curve: Curves.bounceOut, alignment: alignment, isScaled: isScaled);
  }

  @override
  bool get isEnabled => duration.inMilliseconds > 0;

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
    return ScaleWidget(params: this, child: child);
  }
}

extension ScaleParamsExtension on Widget {
  Widget withScale(ScaleParams params) => ScaleWidget(params: params, child: this);
}

class GaplyScalePreset with GaplyPreset<ScaleParams> {
  static final GaplyScalePreset instance = GaplyScalePreset._internal();
  GaplyScalePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const ScaleParams(duration: Duration.zero));
    add('pop', const ScaleParams(curve: Curves.easeInBack));
    add('shrink', const ScaleParams(curve: Curves.easeIn));
    add('grow', const ScaleParams(curve: Curves.easeOut));
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
