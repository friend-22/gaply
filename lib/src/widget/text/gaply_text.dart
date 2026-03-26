import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'text_style.dart';
import 'text_style_modifier.dart';

class GaplyText extends StatelessWidget
    with
        ColorStyleModifier<GaplyText>,
        BlurStyleModifier<GaplyText>,
        ShimmerStyleModifier<GaplyText>,
        MotionStyleModifier<GaplyText>,
        TextStyleModifier<GaplyText> {
  final GaplyTextStyle style;
  final String text;

  const GaplyText(this.text, {super.key, required this.style});

  @override
  GaplyTextStyle get textStyle => style;

  @override
  GaplyText copyWithText(GaplyTextStyle style) => GaplyText(text, style: style);

  @override
  Widget build(BuildContext context) {
    return _GaplyTextWidget(text: text, style: style);
  }
}

class _GaplyTextWidget extends ImplicitlyAnimatedWidget {
  final String text;
  final GaplyTextStyle style;

  _GaplyTextWidget({required this.text, required this.style})
    : super(duration: style.duration, curve: style.curve, onEnd: style.onComplete);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _GaplyTextWidgetState();
}

class _GaplyTextWidgetState extends AnimatedWidgetBaseState<_GaplyTextWidget> {
  _GaplyTextStyleTween? _styleTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _styleTween =
        visitor(
              _styleTween,
              widget.style,
              (dynamic value) => _GaplyTextStyleTween(begin: value as GaplyTextStyle),
            )
            as _GaplyTextStyleTween?;
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = _styleTween?.evaluate(animation) ?? widget.style;

    Widget child = Text(widget.text, style: currentStyle.resolve(context), textAlign: currentStyle.alignRole);

    if (currentStyle.shimmer.hasEffect) {
      child = currentStyle.shimmer.buildWidget(context: context, child: child);
    }

    if (currentStyle.blur.hasEffect) {
      child = currentStyle.blur.buildWidget(context: context, child: child);
    }

    if (currentStyle.motion.hasEffect) {
      child = currentStyle.motion.buildWidget(child: child);
    }

    return child;
  }
}

/// GaplyTextStyle의 lerp 기능을 Tween으로 연결
class _GaplyTextStyleTween extends Tween<GaplyTextStyle> {
  _GaplyTextStyleTween({super.begin});

  @override
  GaplyTextStyle evaluate(Animation<double> animation) => begin!.lerp(end, animation.value);
}
