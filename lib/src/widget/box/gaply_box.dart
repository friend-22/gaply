import 'package:flutter/material.dart';
import 'package:gaply/src/utils/tap_gesture_detector.dart';

import 'package:gaply/src/gaply/styles/styles.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'box_style.dart';
import 'box_style_modifier.dart';

/// A customizable box widget with integrated styling and animation support.
///
/// [GaplyBox] combines layout, visual effects, and animations through [BoxStyle].
/// It supports:
/// - Colors and borders
/// - Shadows and blur effects
/// - Shimmer animations
/// - Sequential animations
/// - Interactive events
///
/// ### Example
/// ```dart
/// GaplyBox(
///   style: BoxStyle()
///       .boxColorRole(ColorRole.primary)
///       .boxRadius(BorderRadius.circular(12))
///       .boxPadding(EdgeInsets.all(16)),
///   child: Text('Styled Box'),
/// )
/// ```
///
/// See also:
/// - [BoxStyle] for styling configuration
/// - [BoxStyleModifier] for fluent API
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
  @override
  BoxStyle get boxStyle => style;

  final BoxStyle style;
  final Widget child;

  const GaplyBox({super.key, required this.style, required this.child});

  @override
  GaplyBox copyWithStyle(BoxStyle style) => GaplyBox(key: key, style: style, child: child);

  @override
  Widget build(BuildContext context) {
    return _GaplyAnimatedBox(style: style, child: child);
  }
}

/// Animated container that interpolates between [BoxStyle] values
class _GaplyAnimatedBox extends ImplicitlyAnimatedWidget {
  final BoxStyle style;
  final Widget child;

  _GaplyAnimatedBox({required this.style, required this.child})
    : super(duration: style.duration, curve: style.curve);

  @override
  ImplicitlyAnimatedWidgetState<_GaplyAnimatedBox> createState() => _GaplyAnimatedBoxState();
}

class _GaplyAnimatedBoxState extends AnimatedWidgetBaseState<_GaplyAnimatedBox> {
  BoxStyleTween? _styleTween;

  /// Cache for decoration to avoid rebuilding every frame
  // BoxDecoration? _cachedDecoration;
  // BoxStyle? _lastStyle;

  @override
  void didUpdateWidget(_GaplyAnimatedBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache when widget updates
    //_cachedDecoration = null;
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _styleTween =
        visitor(_styleTween, widget.style, (dynamic value) => BoxStyleTween(begin: value as BoxStyle))
            as BoxStyleTween?;
  }

  @override
  Widget build(BuildContext context) {
    final BoxStyle currentStyle = _styleTween?.evaluate(animation) ?? widget.style;

    Widget result = widget.child;

    // Determine if heavy effects need optimization
    final needsOptimization =
        currentStyle.shimmer.hasEffect || (currentStyle.blur.hasEffect && currentStyle.motion.hasEffect);

    // Build decoration with caching
    final decoration = _buildDecoration(context, currentStyle);

    result = Container(
      width: currentStyle.layout.width,
      height: currentStyle.layout.height,
      padding: currentStyle.layout.padding,
      margin: currentStyle.layout.margin,
      alignment: currentStyle.layout.alignment,
      decoration: decoration,
      clipBehavior: currentStyle.layout.borderRadius != null ? Clip.antiAlias : Clip.none,
      child: result,
    );

    // Apply effects in order of performance impact (least expensive first)
    if (currentStyle.shimmer.hasEffect) {
      result = currentStyle.shimmer.buildWidget(context: context, child: result);
    }

    if (currentStyle.blur.hasEffect) {
      result = currentStyle.blur.buildWidget(
        context: context,
        borderRadius: currentStyle.layout.borderRadius,
        child: result,
      );
    }

    if (currentStyle.filter.hasEffect) {
      result = currentStyle.filter.buildWidget(context: context, child: result);
    }

    if (currentStyle.noise.hasEffect) {
      result = currentStyle.noise.buildWidget(context: context, child: result);
    }

    if (currentStyle.layout.scale != 1.0) {
      result = Transform.scale(scale: currentStyle.layout.scale, child: result);
    }

    if (needsOptimization) {
      result = RepaintBoundary(child: result);
    }

    if (currentStyle.onPressed != null) {
      result = TapGestureDetector(
        onTap: currentStyle.onPressed,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
      );
    }

    result = currentStyle.motion.buildWidget(child: result);

    return result;
  }

  /// Builds a [BoxDecoration] from the current [BoxStyle].
  ///
  /// Returns null if no decoration is needed (all properties disabled).
  BoxDecoration? _buildDecoration(BuildContext context, BoxStyle style) {
    final hasDecoration =
        style.color.hasEffect ||
        style.borderColor.hasEffect ||
        style.layout.borderWidth > 0 ||
        style.shadows.isNotEmpty ||
        style.gradient.hasEffect;

    if (!hasDecoration) return null;

    return BoxDecoration(
      color: style.color.isVisible ? style.color.resolve(context) : null,
      borderRadius: style.layout.borderRadius,
      border: style.layout.borderWidth > 0
          ? Border.all(
              color: style.borderColor.resolve(context) ?? Colors.transparent,
              width: style.layout.borderWidth,
            )
          : null,
      boxShadow: style.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
      gradient: style.gradient.resolve(context),
    );
  }
}

/// Tween for smooth animation between two [BoxStyle] values.
///
/// This tween handles interpolation of all style properties including
/// colors, shadows, blur effects, and layout parameters.
class BoxStyleTween extends Tween<BoxStyle> {
  BoxStyleTween({super.begin, super.end});

  /// Lerps between begin and end [BoxStyle] at progress [t] (0.0 to 1.0)
  @override
  BoxStyle lerp(double t) {
    assert(begin != null && end != null, 'BoxStyleTween requires begin and end values');

    final result = begin!.lerp(end, t);
    if (t > 0 && t < 1) {
      debugPrint('Animation Progress: ${t.toStringAsFixed(2)}, Scale: ${result.layout.scale}');
    }
    return result;
  }
}
