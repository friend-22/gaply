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
    super.curve = Curves.decelerate,
    super.onComplete,
    this.distance = 8.0,
    this.count = 4.0,
    this.useHaptic = true,
    this.useRepaintBoundary = true,
    this.isVertical = false,
  });

  factory ShakeParams.preset(String name, {VoidCallback? onComplete}) {
    final params = GaplyShakePreset.of(name) ?? GaplyShakePreset.of('none')!;
    return params.copyWith(onComplete: onComplete);
  }

  factory ShakeParams.fast(String name, {VoidCallback? onComplete}) {
    final params = GaplyShakePreset.of(name) ?? GaplyShakePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 300), onComplete: onComplete);
  }

  factory ShakeParams.slow(String name, {VoidCallback? onComplete}) {
    final params = GaplyShakePreset.of(name) ?? GaplyShakePreset.of('none')!;
    return params.copyWith(duration: Duration(milliseconds: 800), onComplete: onComplete);
  }

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
    return ShakeWidget(params: this, child: child);
  }
}

extension ShakeParamsExtension on Widget {
  Widget withShake(ShakeParams params) => ShakeWidget(params: params, child: this);
}

class GaplyShakePreset with GaplyPreset<ShakeParams> {
  static final GaplyShakePreset instance = GaplyShakePreset._internal();

  GaplyShakePreset._internal() {
    register('none', const ShakeParams(duration: Duration.zero));
    register('mild', const ShakeParams(distance: 4.0, count: 2.0, isVertical: false));
    register('normal', const ShakeParams(distance: 8.0, count: 4.0, isVertical: false));
    register('severe', const ShakeParams(distance: 12.0, count: 7.0, isVertical: false));
    register('alert', const ShakeParams(distance: 6.0, count: 7.0, isVertical: false));
    register('nod', const ShakeParams(distance: 6.0, count: 2.0, isVertical: true));
    register('celebrate', const ShakeParams(distance: 10.0, count: 3.0, isVertical: true));
  }

  static void register(String name, ShakeParams params) => instance.add(name, params);

  static ShakeParams? of(String name) => instance.get(name);
}
