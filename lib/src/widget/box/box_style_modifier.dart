import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_style.dart';

mixin BoxStyleModifier<T> on BlurStyleModifier<T>, GradientStyleModifier<T> {
  BoxStyle get boxStyle;

  T copyWithStyle(BoxStyle style);

  @override
  BlurStyle get blurStyle => boxStyle.blur;

  @override
  T copyWithBlur(BlurStyle blur) => copyWithStyle(boxStyle.copyWith(blur: blur));

  @override
  GaplyGradient get gradientStyle => boxStyle.gradient;

  @override
  T copyWithGradient(GaplyGradient gradient) => copyWithStyle(boxStyle.copyWith(gradient: gradient));

  // Color Roles
  T boxColorStyle(GaplyColor color) => copyWithStyle(boxStyle.copyWith(color: color));
  T boxColorRole(
    ColorRole role, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) => boxColorStyle(GaplyColor.fromRole(role, shade: shade, opacity: opacity, autoInvert: autoInvert));
  T boxColor(
    Color custom, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) => boxColorStyle(GaplyColor.fromColor(custom, shade: shade, opacity: opacity, autoInvert: autoInvert));

  // 테두리 시스템
  T boxBorderColorStyle(GaplyColor color) => copyWithStyle(boxStyle.copyWith(borderColor: color));
  T boxBorderColorRole(
    ColorRole role, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) =>
      boxBorderColorStyle(GaplyColor.fromRole(role, shade: shade, opacity: opacity, autoInvert: autoInvert));
  T boxBorderColor(
    Color custom, {
    ColorShade shade = ColorShade.s500,
    ColorOpacity opacity = ColorOpacity.full,
    bool autoInvert = true,
  }) => boxBorderColorStyle(
    GaplyColor.fromColor(custom, shade: shade, opacity: opacity, autoInvert: autoInvert),
  );
  T boxBorderWidth(double value) => copyWithStyle(boxStyle.copyWith(borderWidth: value));

  T boxGlassRole(
    ColorRole value, {
    ColorShade bgShade = ColorShade.s50,
    ColorShade borderShade = ColorShade.s100,
  }) {
    return copyWithStyle(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(role: value, shade: bgShade),
        borderColor: boxStyle.borderColor.copyWith(role: value, shade: borderShade),
      ),
    );
  }

  T boxGlass(Color? value, {ColorShade bgShade = ColorShade.s50, ColorShade borderShade = ColorShade.s100}) {
    return copyWithStyle(
      boxStyle.copyWith(
        color: boxStyle.color.copyWith(customColor: value, shade: bgShade),
        borderColor: boxStyle.borderColor.copyWith(customColor: value, shade: borderShade),
      ),
    );
  }

  // 효과 시스템 (Shimmer & Blur)
  T boxShimmerStyle(GaplyShimmer shimmer) => copyWithStyle(boxStyle.copyWith(shimmer: shimmer));
  T boxShimmerPreset(String name, {int loop = 0}) => boxShimmerStyle(GaplyShimmer.preset(name, loop: loop));

  // T boxBlurStyle(BlurStyle blur) => copyWithStyle(boxStyle.copyWith(blur: blur));
  // T boxBlur(double sigma, {GaplyColor? color}) => boxBlurStyle(
  //   BlurStyle(
  //     sigma: sigma,
  //     color: color ?? const GaplyColor.shadow(opacity: ColorOpacity.o10),
  //   ),
  // );
  // T boxBlurPreset(String name) => boxBlurStyle(BlurStyle.preset(name));

  // 그림자 시스템 (ShadowParams 리스트 대응)
  T boxShadows(List<GaplyShadow> values) => copyWithStyle(boxStyle.copyWith(shadows: values));
  T boxShadowPreset(String name, {GaplyColor? color}) => boxShadows([GaplyShadow.preset(name, color: color)]);
  T boxAddShadow(GaplyShadow shadow) => boxShadows([...boxStyle.shadows, shadow]);
  T boxElevation(double value, {GaplyColor? color}) =>
      boxAddShadow(GaplyShadow.elevation(value, color: color));

  // 🖼️ 레이아웃
  T boxLayoutStyle(GaplyLayout layout) => copyWithStyle(boxStyle.copyWith(layout: layout));
  T boxLayoutPreset(String name) => boxLayoutStyle(GaplyLayout.preset(name));
  T boxWidth(double value) => boxLayoutStyle(boxStyle.layout.copyWith(width: value));
  T boxHeight(double value) => boxLayoutStyle(boxStyle.layout.copyWith(height: value));
  T boxSize(double? w, double? h) => boxLayoutStyle(boxStyle.layout.copyWith(width: w, height: h));
  T boxPadding(EdgeInsetsGeometry value) => boxLayoutStyle(boxStyle.layout.copyWith(padding: value));
  T boxMargin(EdgeInsetsGeometry value) => boxLayoutStyle(boxStyle.layout.copyWith(margin: value));
  T boxAlignment(AlignmentGeometry value) => boxLayoutStyle(boxStyle.layout.copyWith(alignment: value));
  T boxRadius(BorderRadiusGeometry value) => boxLayoutStyle(boxStyle.layout.copyWith(borderRadius: value));
  T boxScale(double value) => boxLayoutStyle(boxStyle.layout.copyWith(scale: value));
  T boxBorderRadius(BorderRadiusGeometry value) =>
      boxLayoutStyle(boxStyle.layout.copyWith(borderRadius: value));

  // GaplyMotion
  T boxMotionStyle(GaplyMotion motion) => copyWithStyle(boxStyle.copyWith(motion: motion));
  T boxMotionPreset(String name) => boxMotionStyle(GaplyMotion.preset(name));
  T boxAddAnimation(GaplyAnimStyle anim) => boxMotionStyle(boxStyle.motion.addAnimation(anim));

  //️ 인터랙션
  T boxOnPressed(VoidCallback? action) => copyWithStyle(boxStyle.copyWith(onPressed: action));

  T boxDuration(Duration value) => copyWithStyle(boxStyle.copyWith(duration: value));
  T boxCurve(Curve value) => copyWithStyle(boxStyle.copyWith(curve: value));

  // 🖼️ Acrylic Effect
  // T acrylicParams(AcrylicParams effect) => copyWith(effect.copyWith(acrylicParams: effect));
  // T boxOpacity(double value) => acrylicParams(effect.acrylicParams.copyWith(opacity: value));
  // T boxBlur(double value) => acrylicParams(effect.acrylicParams.copyWith(blur: value));
  // T boxElevation(double value) => acrylicParams(effect.acrylicParams.copyWith(elevation: value));
  // T get acrylicNone => acrylicParams(AcrylicParams.none());
  // T get acrylicLow => acrylicParams(AcrylicParams.low());
  // T get acrylicMedium => acrylicParams(AcrylicParams.medium());
  // T get acrylicHigh => acrylicParams(AcrylicParams.high());
  // T get acrylicExtra => acrylicParams(AcrylicParams.extra());
  // T get acrylicApple => acrylicParams(AcrylicParams.apple());
  // T get acrylicWindows => acrylicParams(AcrylicParams.windows());
  // T get acrylicGoogle => acrylicParams(AcrylicParams.google());

  //  T blurParams(BlurParams effect) => copyWith(effect.copyWith(blur: effect));
  // T blurColorR(ColorRole value) => blurParams(effect.blur.copyWith(role: value));
  // T blurColor(Color? value) => blurParams(effect.blur.copyWith(customColor: value));

  // 🖼️ Shadow Effect
  // T shadowParams(GaplyShadow effect) => acrylicParams(effect.acrylicParams.copyWith(shadowParams: effect));
  // T get shadowSmall => shadowParams(GaplyShadow.small());
  // T get shadowMedium => shadowParams(GaplyShadow.medium());
  // T get shadowLarge => shadowParams(GaplyShadow.large());
  // T get shadowBase => shadowParams(GaplyShadow.base());
  // T get shadowNone => shadowParams(GaplyShadow.none());

  // 🖼️ Box Alignment
  // T get center => copyWith(effect.copyWith(center: true));
  // T get uncenter => copyWith(effect.copyWith(center: false));

  // 📦 Animation Effects
  // T updateShake(ShakeType newType) {
  //   final newParams = effect.aniParam.copyWith(shakeType: newType);
  //   return copyWith(effect.copyWith(aniParam: newParams));
  // }

  // T get shakeNone => updateShake(ShakeType.none);
  // T get shakeMild => updateShake(ShakeType.mild);
  // T get shakeNormal => updateShake(ShakeType.normal);
  // T get shakeSevere => updateShake(ShakeType.severe);
  // T get shakeAlert => updateShake(ShakeType.alert);
  // T get shakeNod => updateShake(ShakeType.nod);
  // T get shakeCelebrate => updateShake(ShakeType.celebrate);
  // T onShakeComplete(VoidCallback? action) {
  //   final newParams = effect.aniParam.copyWith(onShakeComplete: action);
  //   return copyWith(effect.copyWith(aniParam: newParams));
  // }

  // 📦 Slide Effects
  // T _updateSlide(SlideType newType, bool isVisible) {
  //   final newParams = effect.aniParam.copyWith(slideType: newType, isVisible: isVisible);
  //   return copyWith(effect.copyWith(aniParam: newParams));
  // }
  //
  // T slideVisible(bool isVisible) {
  //   final newParams = effect.aniParam.copyWith(isVisible: isVisible);
  //   return copyWith(effect.copyWith(aniParam: newParams));
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
  //   final newParams = effect.aniParam.copyWith(onSlideComplete: action);
  //   return copyWith(effect.copyWith(aniParam: newParams));
  // }

  // 📦 Animation Sequence
  // T _updateAnimation(AniSequence newType) {
  //   final newParams = effect.aniParam.copyWith(sequence: newType);
  //   return copyWith(effect.copyWith(aniParam: newParams));
  // }
  //
  // T get animationNone => _updateAnimation(AniSequence.none);
  // T get slideThenShake => _updateAnimation(AniSequence.slideThenShake);
  // T get shakeThenSlide => _updateAnimation(AniSequence.shakeThenSlide);
  // T get parallel => _updateAnimation(AniSequence.parallel);
  //
  // T onPress(VoidCallback? action) {
  //   return copyWith(effect.copyWith(onPressed: action));
  // }

  // T _updateProgress(ProgressParams effect) => copyWith(effect.copyWith(progressParams: effect));
  // T progressValue(double value) => _updateProgress(effect.progressParams.copyWith(value: value));
  // T progressType(ProgressType type) => _updateProgress(effect.progressParams.copyWith(type: type));
  // T progressStrokeWidth(double value) => _updateProgress(effect.progressParams.copyWith(strokeWidth: value));
  // T progressSize(double value) =>
  //     _updateProgress(effect.progressParams.copyWith(width: value, height: value));
  // T progressWidth(double value) => _updateProgress(effect.progressParams.copyWith(width: value));
  // T progressHeight(double value) => _updateProgress(effect.progressParams.copyWith(height: value));
  // T progressSizeAmount(double value) =>
  //     _updateProgress(effect.progressParams.copyWith(widthAmount: value, heightAmount: value));
  // T progressWidthAmount(double value) => _updateProgress(effect.progressParams.copyWith(widthAmount: value));
  // T progressHeightAmount(double value) =>
  //     _updateProgress(effect.progressParams.copyWith(heightAmount: value));
  // T progressGaplyColor(GaplyColor color) => _updateProgress(effect.progressParams.copyWith(color: color));
  // T progressColorR(ColorRole value) =>
  //     progressGaplyColor(effect.progressParams.color.copyWith(role: value));
  // T progressColor(Color? value) => progressGaplyColor(effect.progressParams.color.copyWith(color: value));
  // T progressBotPosition(double value) => _updateProgress(effect.progressParams.copyWith(botPosition: value));
}
