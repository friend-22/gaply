import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'gaply_text.dart';
import 'gaply_text_modifier.dart';

class GaplyTextWidget extends StatelessWidget
    with
        GaplyColorModifier<GaplyTextWidget>,
        GaplyBlurModifier<GaplyTextWidget>,
        GaplyShimmerModifier<GaplyTextWidget>,
        GaplyMotionModifier<GaplyTextWidget>,
        GaplyTextModifier<GaplyTextWidget> {
  @override
  final GaplyText gaplyText;
  final String text;

  const GaplyTextWidget(this.text, {super.key, required this.gaplyText});

  @override
  GaplyTextWidget copyWithText(GaplyText style) => GaplyTextWidget(text, gaplyText: style);

  @override
  Widget build(BuildContext context) {
    return _GaplyTextWidget(text: text, gaplyText: gaplyText);
  }
}

class _GaplyTextWidget extends ImplicitlyAnimatedWidget {
  final String text;
  final GaplyText gaplyText;

  _GaplyTextWidget({required this.text, required this.gaplyText})
    : super(duration: gaplyText.duration, curve: gaplyText.curve, onEnd: gaplyText.onComplete);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _GaplyTextWidgetState();
}

class _GaplyTextWidgetState extends AnimatedWidgetBaseState<_GaplyTextWidget> {
  _GaplyTextTween? _gaplyTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gaplyTween =
        visitor(_gaplyTween, widget.gaplyText, (dynamic value) => _GaplyTextTween(begin: value as GaplyText))
            as _GaplyTextTween?;
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = _gaplyTween?.evaluate(animation) ?? widget.gaplyText;

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

class _GaplyTextTween extends Tween<GaplyText> {
  _GaplyTextTween({super.begin});

  @override
  GaplyText evaluate(Animation<double> animation) => begin!.lerp(end, animation.value);
}
