import 'package:flutter/animation.dart';
import 'package:gaply/src/profiler/gaply_profiler.dart';
import 'gaply_fade.dart';

mixin GaplyFadeModifier<T> {
  GaplyFade get gaplyFade;

  T copyWithFade(GaplyFade fade);

  T fadeStyle(GaplyFade fade) => copyWithFade(fade);

  T fadeOf(Object key, {GaplyProfiler? profiler, VoidCallback? onComplete}) =>
      copyWithFade(GaplyFade.of(key, profiler: profiler, onComplete: onComplete));

  T fadeIn() => copyWithFade(gaplyFade.copyWith(isVisible: true));

  T fadeOut() => copyWithFade(gaplyFade.copyWith(isVisible: false));

  T fadeVisible(bool visible) => copyWithFade(gaplyFade.copyWith(isVisible: visible));

  T fadeDuration(Duration duration) => copyWithFade(gaplyFade.copyWith(duration: duration));

  T fadeCurve(Curve curve) => copyWithFade(gaplyFade.copyWith(curve: curve));

  T fadeDelay(Duration delay) => copyWithFade(gaplyFade.copyWith(delay: delay));

  T fadeOnComplete(VoidCallback onComplete) => copyWithFade(gaplyFade.copyWith(onComplete: onComplete));
}
