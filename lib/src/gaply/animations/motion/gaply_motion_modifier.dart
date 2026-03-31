import 'package:flutter/animation.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/core/gaply_core.dart';
import 'gaply_motion.dart';

mixin GaplyMotionModifier<T> {
  GaplyMotion get gaplyMotion;

  T copyWithMotion(GaplyMotion motion);

  T motionStyle(GaplyMotion value) => copyWithMotion(value);

  T motionOf(Object key, {GaplyProfiler? profiler, VoidCallback? onComplete}) =>
      copyWithMotion(GaplyMotion.of(key, profiler: profiler, onComplete: onComplete));

  T motionAdd(GaplyAnimStyle anim) => copyWithMotion(gaplyMotion.addAnimation(anim));

  T motionAll(List<GaplyAnimStyle> animations) => copyWithMotion(gaplyMotion.addAnimations(animations));

  T motionChild(GaplyMotion child) =>
      copyWithMotion(gaplyMotion.copyWith(children: [...gaplyMotion.children, child]));

  T motionClear() => copyWithMotion(const GaplyMotion.none());

  T motionOnComplete(VoidCallback onComplete) => copyWithMotion(gaplyMotion.copyWith(onComplete: onComplete));
}
