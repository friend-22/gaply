import 'package:flutter/animation.dart';

import 'gaply_motion.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';

mixin MotionStyleModifier<T> {
  GaplyMotion get motionStyle;
  T copyWithMotion(GaplyMotion motion);

  T motionStyleSet(GaplyMotion value) => copyWithMotion(value);

  // T motionPreset(Object name) => copyWithMotion(GaplyMotion.preset(name));

  T motionAdd(GaplyAnimStyle anim) => copyWithMotion(motionStyle.addAnimation(anim));

  T motionAll(List<GaplyAnimStyle> animations) => copyWithMotion(motionStyle.addAnimations(animations));

  T motionChild(GaplyMotion child) =>
      copyWithMotion(motionStyle.copyWith(children: [...motionStyle.children, child]));

  T motionClear() => copyWithMotion(const GaplyMotion.none());

  T motionOnComplete(VoidCallback onComplete) => copyWithMotion(motionStyle.copyWith(onComplete: onComplete));
}
