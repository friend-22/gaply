import 'package:flutter/animation.dart';

import 'fade_style.dart';

mixin FadeStyleModifier<T> {
  FadeStyle get fadeStyle;

  T copyWithFade(FadeStyle fade);

  T fadeStyleSet(FadeStyle fade) => copyWithFade(fade);

  T fadePreset(String name) => copyWithFade(FadeStyle.preset(name));

  T fadeIn() => copyWithFade(fadeStyle.copyWith(isVisible: true));

  T fadeOut() => copyWithFade(fadeStyle.copyWith(isVisible: false));

  T fadeVisible(bool visible) => copyWithFade(fadeStyle.copyWith(isVisible: visible));

  T fadeDuration(Duration duration) => copyWithFade(fadeStyle.copyWith(duration: duration));

  T fadeCurve(Curve curve) => copyWithFade(fadeStyle.copyWith(curve: curve));

  T fadeDelay(Duration delay) => copyWithFade(fadeStyle.copyWith(delay: delay));

  T fadeOnComplete(VoidCallback onComplete) => copyWithFade(fadeStyle.copyWith(onComplete: onComplete));
}
