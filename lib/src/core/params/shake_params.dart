import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/shake_widget.dart';
import '../base/animation_params.dart';

@immutable
class ShakeParams extends AnimationParams {
  final double distance;
  final double count;
  final bool useHaptic;
  final bool useRepaintBoundary;
  final bool isVertical;

  const ShakeParams({
    super.duration,
    super.curve,
    super.onComplete,
    this.distance = 8.0,
    this.count = 4.0,
    this.useHaptic = true,
    this.useRepaintBoundary = true,
    this.isVertical = false,
  });

  const ShakeParams.none() : this(duration: Duration.zero, curve: Curves.linear, distance: 0.0, count: 0.0);

  factory ShakeParams.preset(String name, {double? distance, double? count, bool? isVertical}) {
    final params = GaplyShakePreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown shake preset: "$name"');
    }
    return params.copyWith(distance: distance, count: count, isVertical: isVertical);
  }

  ShakeParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
  }

  ShakeParams withIntensity(double intensity) {
    return copyWith(distance: distance * intensity, count: (count * intensity).toDouble());
  }

  @override
  bool get isEnabled => duration.inMilliseconds > 0 && distance > 0;

  @override
  ShakeParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    double? distance,
    double? count,
    bool? useHaptic,
    bool? useRepaintBoundary,
    bool? isVertical,
  }) {
    return ShakeParams(
      distance: distance ?? this.distance,
      count: count ?? this.count,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      useHaptic: useHaptic ?? this.useHaptic,
      useRepaintBoundary: useRepaintBoundary ?? this.useRepaintBoundary,
      onComplete: onComplete ?? this.onComplete,
      isVertical: isVertical ?? this.isVertical,
    );
  }

  @override
  ShakeParams lerp(AnimationParams? other, double t) {
    if (other is! ShakeParams) return this;
    return ShakeParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      distance: lerpDouble(distance, other.distance, t) ?? distance,
      count: lerpDouble(count, other.count, t) ?? count,
      useHaptic: t < 0.5 ? useHaptic : other.useHaptic,
      useRepaintBoundary: t < 0.5 ? useRepaintBoundary : other.useRepaintBoundary,
      isVertical: t < 0.5 ? isVertical : other.isVertical,
    );
  }

  @override
  List<Object?> get props => [...super.props, distance, count, useHaptic, useRepaintBoundary, isVertical];

  Widget buildWidget({required Widget child}) {
    return ShakeTrigger(params: this, trigger: DateTime.now(), child: child);
  }
}

extension ShakeParamsExtension on Widget {
  Widget withShake(ShakeParams params) => ShakeTrigger(params: params, trigger: DateTime.now(), child: this);
}

class GaplyShakePreset with GaplyPreset<ShakeParams> {
  static final GaplyShakePreset instance = GaplyShakePreset._internal();
  GaplyShakePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
    add(
      'mild',
      const ShakeParams(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        distance: 4.0,
        count: 2.0,
        isVertical: false,
      ),
    );
    add(
      'normal',
      const ShakeParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 8.0,
        count: 4.0,
        isVertical: false,
      ),
    );
    add(
      'severe',
      const ShakeParams(
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate,
        distance: 12.0,
        count: 7.0,
        isVertical: false,
      ),
    );
    add(
      'alert',
      const ShakeParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 6.0,
        count: 7.0,
        isVertical: false,
      ),
    );
    add(
      'nod',
      const ShakeParams(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        distance: 6.0,
        count: 2.0,
        isVertical: true,
      ),
    );
    add(
      'celebrate',
      const ShakeParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
        distance: 10.0,
        count: 3.0,
        isVertical: true,
      ),
    );
  }

  static void register(String name, ShakeParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static ShakeParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
