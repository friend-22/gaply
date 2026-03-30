import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/effects/effects.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'gaply_box.dart';
import 'gaply_box_modifier.dart';

class GaplyBoxWidget extends StatelessWidget
    with
        GaplyColorModifier<GaplyBoxWidget>,
        GaplyBorderColorModifier<GaplyBoxWidget>,
        GaplyLayoutModifier<GaplyBoxWidget>,
        GaplyBlurModifier<GaplyBoxWidget>,
        GaplyGradientModifier<GaplyBoxWidget>,
        GaplyShimmerModifier<GaplyBoxWidget>,
        GaplyFilterModifier<GaplyBoxWidget>,
        GaplyNoiseModifier<GaplyBoxWidget>,
        GaplyManyShadowModifier<GaplyBoxWidget>,
        GaplyMotionModifier<GaplyBoxWidget>,
        GaplyBoxModifier<GaplyBoxWidget> {
  @override
  final GaplyBox gaplyBox;
  final Widget child;

  const GaplyBoxWidget({super.key, required this.gaplyBox, required this.child});

  @override
  GaplyBoxWidget copyWithBox(GaplyBox box) => GaplyBoxWidget(key: key, gaplyBox: box, child: child);

  @override
  Widget build(BuildContext context) {
    return _GaplyBoxWidget(gaplyBox: gaplyBox, child: child);
  }
}

class _GaplyBoxWidget extends ImplicitlyAnimatedWidget {
  final GaplyBox gaplyBox;
  final Widget child;

  _GaplyBoxWidget({required this.gaplyBox, required this.child})
    : super(duration: gaplyBox.duration, curve: gaplyBox.curve, onEnd: gaplyBox.onComplete);

  @override
  ImplicitlyAnimatedWidgetState<_GaplyBoxWidget> createState() => _GaplyBoxWidgetState();
}

class _GaplyBoxWidgetState extends AnimatedWidgetBaseState<_GaplyBoxWidget> {
  _GaplyBoxTween? _gaplyTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gaplyTween =
        visitor(_gaplyTween, widget.gaplyBox, (dynamic value) => _GaplyBoxTween(begin: value as GaplyBox))
            as _GaplyBoxTween?;
  }

  @override
  Widget build(BuildContext context) {
    return widget.gaplyBox.profiler.trace(() {
      final currentStyle = _gaplyTween?.evaluate(animation) ?? widget.gaplyBox;

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
    }, tag: 'build');
  }

  BoxDecoration? _buildDecoration(BuildContext context, GaplyBox style) {
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

class _GaplyBoxTween extends Tween<GaplyBox> {
  _GaplyBoxTween({super.begin});

  @override
  GaplyBox lerp(double t) => begin!.lerp(end, t);
}
