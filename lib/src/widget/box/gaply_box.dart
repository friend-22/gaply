import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_style.dart';
import 'box_style_modifier.dart';

class GaplyBox extends StatelessWidget
    with
        ColorStyleModifier<GaplyBox>,
        BorderColorStyleModifier<GaplyBox>,
        LayoutStyleModifier<GaplyBox>,
        BlurStyleModifier<GaplyBox>,
        GradientStyleModifier<GaplyBox>,
        ShimmerStyleModifier<GaplyBox>,
        FilterStyleModifier<GaplyBox>,
        NoiseStyleModifier<GaplyBox>,
        ManyShadowStyleModifier<GaplyBox>,
        MotionStyleModifier<GaplyBox>,
        BoxStyleModifier<GaplyBox> {
  final BoxStyle style;
  final Widget child;

  const GaplyBox({super.key, required this.style, required this.child});

  @override
  BoxStyle get boxStyle => style;

  @override
  GaplyBox copyWithBox(BoxStyle box) => GaplyBox(key: key, style: box, child: child);

  @override
  Widget build(BuildContext context) {
    return _GaplyBoxWidget(style: style, child: child);
  }
}

class _GaplyBoxWidget extends ImplicitlyAnimatedWidget {
  final BoxStyle style;
  final Widget child;

  _GaplyBoxWidget({required this.style, required this.child})
    : super(duration: style.duration, curve: style.curve, onEnd: style.onComplete);

  @override
  ImplicitlyAnimatedWidgetState<_GaplyBoxWidget> createState() => _GaplyBoxWidgetState();
}

class _GaplyBoxWidgetState extends AnimatedWidgetBaseState<_GaplyBoxWidget> {
  _BoxStyleTween? _styleTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _styleTween =
        visitor(_styleTween, widget.style, (dynamic value) => _BoxStyleTween(begin: value as BoxStyle))
            as _BoxStyleTween?;
  }

  @override
  Widget build(BuildContext context) {
    final currentStyle = _styleTween?.evaluate(animation) ?? widget.style;

    final layout = currentStyle.layout;

    final bool staticEffect = currentStyle.noise.hasEffect || currentStyle.filter.hasEffect;
    final bool dynamicEffect = currentStyle.shimmer.hasEffect;

    Widget result = Container(
      width: layout.width,
      height: layout.height,
      padding: layout.padding,
      margin: layout.margin,
      alignment: layout.alignment,
      decoration: _buildDecoration(context, currentStyle),
      clipBehavior: layout.borderRadius != null ? Clip.antiAlias : Clip.none,
      child: widget.child,
    );

    if (currentStyle.noise.hasEffect) {
      result = currentStyle.noise.buildWidget(context: context, child: result);
    }

    if (currentStyle.filter.hasEffect) {
      result = currentStyle.filter.buildWidget(context: context, child: result);
    }

    if (dynamicEffect) {
      result = currentStyle.shimmer.buildWidget(context: context, child: result);
    }

    if (staticEffect || dynamicEffect) {
      result = RepaintBoundary(child: result);
    }

    if (currentStyle.onPressed != null) {
      result = GestureDetector(
        onTap: currentStyle.onPressed,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
      );
    }

    if (layout.scale != 1.0) {
      result = Transform.scale(scale: layout.scale, child: result);
    }

    if (currentStyle.motion.hasEffect) {
      result = currentStyle.motion.buildWidget(child: result);
    }

    return result;
  }

  BoxDecoration? _buildDecoration(BuildContext context, BoxStyle style) {
    if (!style.hasEffect) return null;

    final resolvedColor = style.color.resolve(context) ?? Colors.transparent;
    final resolvedBorderColor = style.borderColor.resolve(context) ?? Colors.transparent;

    return BoxDecoration(
      color: resolvedColor,
      borderRadius: style.layout.borderRadius,
      border: style.layout.borderWidth > 0
          ? Border.all(color: resolvedBorderColor, width: style.layout.borderWidth)
          : null,
      boxShadow: style.shadows.isEmpty
          ? null
          : style.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
      gradient: style.gradient.hasEffect ? style.gradient.resolve(context) : null,
    );
  }
}

class _BoxStyleTween extends Tween<BoxStyle> {
  _BoxStyleTween({super.begin});

  @override
  BoxStyle lerp(double t) => begin!.lerp(end, t);
}
