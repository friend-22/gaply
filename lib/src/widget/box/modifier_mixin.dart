import 'package:flutter/material.dart';
import 'package:gaply/src/core/base/animation_params.dart';
import 'package:gaply/src/core/params/animation_sequence_params.dart';
import 'package:gaply/src/core/params/blur_params.dart';
import 'package:gaply/src/core/params/box_params.dart';
import 'package:gaply/src/core/params/color_params.dart';
import 'package:gaply/src/core/params/shadow_params.dart';
import 'package:gaply/src/core/params/shimmer_params.dart';

mixin BoxStyleModifierMixin<T> {
  BoxParams get _params => this as BoxParams;

  T copyWith(BoxParams params);

  // Box Types
  T _updateBox(BoxType value) => copyWith(_params.copyWith(boxType: value));
  T get noBox => _updateBox(BoxType.none);
  T get box => _updateBox(BoxType.box);
  // T get withFocusOutline => copyWith(_params.copyWith(useFocusOutline: true));
  // T get focused => copyWith(_params.copyWith(focused: true));
  // T get unfocused => copyWith(_params.copyWith(focused: false));

  // Color Roles
  T colorParams(ColorParams params) => copyWith(_params.copyWith(color: params));
  T colorR(ColorRole role) => colorParams(_params.color.copyWith(role: role));
  T color(Color? custom) => colorParams(_params.color.copyWith(customColor: custom));
  T colorShade(ColorShade shade) => colorParams(_params.color.copyWith(shade: shade));
  T colorOpacity(ColorOpacity opacity) => colorParams(_params.color.copyWith(opacity: opacity));

  // 테두리 시스템
  T borderColorParams(ColorParams params) => copyWith(_params.copyWith(borderColor: params));
  T borderColorR(ColorRole role) => borderColorParams(_params.borderColor.copyWith(role: role));
  T borderWidth(double value) => copyWith(_params.copyWith(borderWidth: value));
  T borderRadius(BorderRadiusGeometry value) => copyWith(_params.copyWith(borderRadius: value));

  T boxGlassR(
    ColorRole value, {
    ColorShade bgShade = ColorShade.s50,
    ColorShade borderShade = ColorShade.s100,
  }) {
    return copyWith(
      _params.copyWith(
        color: _params.color.copyWith(role: value, shade: bgShade),
        borderColor: _params.borderColor.copyWith(role: value, shade: borderShade),
      ),
    );
  }

  T boxGlass(Color? value, {ColorShade bgShade = ColorShade.s50, ColorShade borderShade = ColorShade.s100}) {
    return copyWith(
      _params.copyWith(
        color: _params.color.copyWith(customColor: value, shade: bgShade),
        borderColor: _params.borderColor.copyWith(customColor: value, shade: borderShade),
      ),
    );
  }

  // 효과 시스템 (Shimmer & Blur)
  T shimmer(ShimmerParams shimmer) => copyWith(_params.copyWith(shimmer: shimmer));
  T shimmerPreset(String name, {int loop = 0}) => shimmer(ShimmerParams.preset(name, loop: loop));
  T get useShimmer => shimmer(const ShimmerParams());

  T blur(BlurParams blur) => copyWith(_params.copyWith(blur: blur));
  T blurPreset(String name) => blur(BlurParams.preset(name));

  // 그림자 시스템 (ShadowParams 리스트 대응)
  T shadows(List<ShadowParams> values) => copyWith(_params.copyWith(shadows: values));
  T addShadow(ShadowParams shadow) => shadows([..._params.shadows, shadow]);
  T elevation(double value) => addShadow(ShadowParams.elevation(value));

  // 🖼️ 레이아웃
  T boxWidth(double value) => copyWith(_params.copyWith(width: value));
  T boxHeight(double value) => copyWith(_params.copyWith(height: value));
  T boxSize(double? w, double? h) => copyWith(_params.copyWith(width: w, height: h));
  T padding(EdgeInsetsGeometry value) => copyWith(_params.copyWith(padding: value));
  T margin(EdgeInsetsGeometry value) => copyWith(_params.copyWith(margin: value));
  T alignment(AlignmentGeometry value) => copyWith(_params.copyWith(alignment: value));

  // AnimationSequenceParams
  T animation(AnimationSequenceParams anim) => copyWith(_params.copyWith(animation: anim));
  T animPreset(String name) => animation(AnimationSequenceParams.preset(name));
  T addEffect(AnimationParams effect) => animation(_params.animation.add(effect));

  //️ 인터랙션
  T onPressed(VoidCallback? action) => copyWith(_params.copyWith(onPressed: action));

  // 🖼️ Acrylic Effect
  // T acrylicParams(AcrylicParams params) => copyWith(_params.copyWith(acrylicParams: params));
  // T boxOpacity(double value) => acrylicParams(_params.acrylicParams.copyWith(opacity: value));
  // T boxBlur(double value) => acrylicParams(_params.acrylicParams.copyWith(blur: value));
  // T boxElevation(double value) => acrylicParams(_params.acrylicParams.copyWith(elevation: value));
  // T get acrylicNone => acrylicParams(AcrylicParams.none());
  // T get acrylicLow => acrylicParams(AcrylicParams.low());
  // T get acrylicMedium => acrylicParams(AcrylicParams.medium());
  // T get acrylicHigh => acrylicParams(AcrylicParams.high());
  // T get acrylicExtra => acrylicParams(AcrylicParams.extra());
  // T get acrylicApple => acrylicParams(AcrylicParams.apple());
  // T get acrylicWindows => acrylicParams(AcrylicParams.windows());
  // T get acrylicGoogle => acrylicParams(AcrylicParams.google());

  T blurParams(BlurParams params) => copyWith(_params.copyWith(blur: params));
  // T blurColorR(ColorRole value) => blurParams(_params.blur.copyWith(role: value));
  // T blurColor(Color? value) => blurParams(_params.blur.copyWith(customColor: value));

  // 🖼️ Shadow Effect
  // T shadowParams(ShadowParams params) => acrylicParams(_params.acrylicParams.copyWith(shadowParams: params));
  // T get shadowSmall => shadowParams(ShadowParams.small());
  // T get shadowMedium => shadowParams(ShadowParams.medium());
  // T get shadowLarge => shadowParams(ShadowParams.large());
  // T get shadowBase => shadowParams(ShadowParams.base());
  // T get shadowNone => shadowParams(ShadowParams.none());

  // 🖼️ Box Alignment
  // T get center => copyWith(_params.copyWith(center: true));
  // T get uncenter => copyWith(_params.copyWith(center: false));

  // 📦 Animation Effects
  // T updateShake(ShakeType newType) {
  //   final newParams = _params.aniParam.copyWith(shakeType: newType);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }

  // T get shakeNone => updateShake(ShakeType.none);
  // T get shakeMild => updateShake(ShakeType.mild);
  // T get shakeNormal => updateShake(ShakeType.normal);
  // T get shakeSevere => updateShake(ShakeType.severe);
  // T get shakeAlert => updateShake(ShakeType.alert);
  // T get shakeNod => updateShake(ShakeType.nod);
  // T get shakeCelebrate => updateShake(ShakeType.celebrate);
  // T onShakeComplete(VoidCallback? action) {
  //   final newParams = _params.aniParam.copyWith(onShakeComplete: action);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }

  // 📦 Slide Effects
  // T _updateSlide(SlideType newType, bool isVisible) {
  //   final newParams = _params.aniParam.copyWith(slideType: newType, isVisible: isVisible);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }
  //
  // T slideVisible(bool isVisible) {
  //   final newParams = _params.aniParam.copyWith(isVisible: isVisible);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }

  // T get slideNone => _updateSlide(SlideType.none, true);
  // T get slideLeftIn => _updateSlide(SlideType.slideLeft, true);
  // T get slideRightIn => _updateSlide(SlideType.slideRight, true);
  // T get slideUpIn => _updateSlide(SlideType.slideUp, true);
  // T get slideDownIn => _updateSlide(SlideType.slideDown, true);
  // T get slideLeftOut => _updateSlide(SlideType.slideLeft, false);
  // T get slideRightOut => _updateSlide(SlideType.slideRight, false);
  // T get slideUpOut => _updateSlide(SlideType.slideUp, false);
  // T get slideDownOut => _updateSlide(SlideType.slideDown, false);
  // T onSlideComplete(VoidCallback? action) {
  //   final newParams = _params.aniParam.copyWith(onSlideComplete: action);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }

  // 📦 Animation Sequence
  // T _updateAnimation(AniSequence newType) {
  //   final newParams = _params.aniParam.copyWith(sequence: newType);
  //   return copyWith(_params.copyWith(aniParam: newParams));
  // }
  //
  // T get animationNone => _updateAnimation(AniSequence.none);
  // T get slideThenShake => _updateAnimation(AniSequence.slideThenShake);
  // T get shakeThenSlide => _updateAnimation(AniSequence.shakeThenSlide);
  // T get parallel => _updateAnimation(AniSequence.parallel);
  //
  // T onPress(VoidCallback? action) {
  //   return copyWith(_params.copyWith(onPressed: action));
  // }

  // T _updateProgress(ProgressParams params) => copyWith(_params.copyWith(progressParams: params));
  // T progressValue(double value) => _updateProgress(_params.progressParams.copyWith(value: value));
  // T progressType(ProgressType type) => _updateProgress(_params.progressParams.copyWith(type: type));
  // T progressStrokeWidth(double value) => _updateProgress(_params.progressParams.copyWith(strokeWidth: value));
  // T progressSize(double value) =>
  //     _updateProgress(_params.progressParams.copyWith(width: value, height: value));
  // T progressWidth(double value) => _updateProgress(_params.progressParams.copyWith(width: value));
  // T progressHeight(double value) => _updateProgress(_params.progressParams.copyWith(height: value));
  // T progressSizeAmount(double value) =>
  //     _updateProgress(_params.progressParams.copyWith(widthAmount: value, heightAmount: value));
  // T progressWidthAmount(double value) => _updateProgress(_params.progressParams.copyWith(widthAmount: value));
  // T progressHeightAmount(double value) =>
  //     _updateProgress(_params.progressParams.copyWith(heightAmount: value));
  // T progressColorParams(ColorParams color) => _updateProgress(_params.progressParams.copyWith(color: color));
  // T progressColorR(ColorRole value) =>
  //     progressColorParams(_params.progressParams.color.copyWith(role: value));
  // T progressColor(Color? value) => progressColorParams(_params.progressParams.color.copyWith(color: value));
  // T progressBotPosition(double value) => _updateProgress(_params.progressParams.copyWith(botPosition: value));
}
