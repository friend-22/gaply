import 'package:flutter/material.dart';
import 'package:gaply/src/utils/tap_gesture_detector.dart';

import 'box_style.dart';
import 'box_style_modifier.dart';

class GaplyBox extends StatelessWidget with BoxStyleModifier<GaplyBox> {
  @override
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

    // [최적화 2] Shimmer나 Blur 같이 연산량이 많은 효과가 있을 때만 RepaintBoundary 적용
    final bool needsBoundary = currentStyle.shimmer.hasEffect || currentStyle.blur.hasEffect;

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

    if (currentStyle.layout.scale != 1.0) {
      result = Transform.scale(scale: currentStyle.layout.scale, child: result);
    }

    if (needsBoundary) {
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

  BoxDecoration? _buildDecoration(BuildContext context, BoxStyle style) {
    final hasDecoration =
        style.color.hasEffect ||
        style.borderColor.hasEffect ||
        style.borderWidth > 0 ||
        style.shadows.isNotEmpty ||
        style.gradient.hasEffect;

    if (!hasDecoration) return null;

    return BoxDecoration(
      color: style.color.isVisible ? style.color.resolve(context) : null,
      borderRadius: style.layout.borderRadius,
      border: style.borderWidth > 0
          ? Border.all(
              color: style.borderColor.resolve(context) ?? Colors.transparent,
              width: style.borderWidth,
            )
          : null,
      boxShadow: style.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
      gradient: style.gradient.resolve(context),
    );
  }
}

/// BoxStyle 전용 Tween
class BoxStyleTween extends Tween<BoxStyle> {
  BoxStyleTween({super.begin, super.end});

  @override
  BoxStyle lerp(double t) {
    final result = begin!.lerp(end, t);
    // 애니메이션 중일 때만 로그 출력
    if (t > 0 && t < 1) {
      debugPrint('Animation Progress: ${t.toStringAsFixed(2)}, Scale: ${result.layout.scale}');
    }
    return result;
  }
}

// class GaplyBox extends StatelessWidget with BoxStyleModifier<GaplyBox> {
//   @override
//   final BoxStyle style;
//   final Widget child;
//
//   const GaplyBox({super.key, required this.style, required this.child});
//
//   @override
//   GaplyBox copyWithStyle(BoxStyle style) => GaplyBox(key: key, style: style, child: child);
//
//   @override
//   Widget build(BuildContext context) {
//     Widget result = child;
//
//     final decoration = _buildDecoration(context);
//
//     result = AnimatedContainer(
//       duration: style.duration,
//       curve: style.curve,
//       width: style.layout.width,
//       height: style.layout.height,
//       padding: style.layout.padding,
//       margin: style.layout.margin,
//       alignment: style.layout.alignment,
//       decoration: decoration,
//       clipBehavior: style.layout.borderRadius != null ? Clip.antiAlias : Clip.none,
//       child: result,
//     );
//
//     if (style.shimmer.isEnabled) {
//       result = style.shimmer.buildWidget(context: context, child: result);
//     }
//
//     if (style.blur.isEnabled) {
//       result = style.blur.buildWidget(
//         context: context,
//         borderRadius: style.layout.borderRadius,
//         child: result,
//       );
//     }
//
//     if (style.onPressed != null) {
//       result = TapGestureDetector(
//         onTap: style.onPressed,
//         behavior: HitTestBehavior.opaque,
//         child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
//       );
//     }
//
//     result = style.animations.buildWidget(child: result);
//
//     return result;
//   }
//
//   BoxDecoration? _buildDecoration(BuildContext context) {
//     final hasDecoration =
//         style.color.isEnabled ||
//         style.borderColor.isEnabled ||
//         style.borderWidth > 0 ||
//         style.shadows.isNotEmpty ||
//         style.gradient.isEnabled;
//
//     if (!hasDecoration) return null;
//
//     return BoxDecoration(
//       color: style.color.isVisible ? style.color.resolve(context) : null,
//       borderRadius: style.layout.borderRadius,
//       border: style.borderWidth > 0
//           ? Border.all(
//               color: style.borderColor.resolve(context) ?? Colors.transparent,
//               width: style.borderWidth,
//             )
//           : null,
//       boxShadow: style.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
//       gradient: style.gradient.resolve(context),
//     );
//   }
// }

// class GaplyBox extends StatelessWidget with BoxStyleModifier<GaplyBox> {
//   @override
//   final BoxStyle style;
//   final Widget child;
//
//   const GaplyBox({super.key, required this.style, required this.child});
//
//   @override
//   GaplyBox copyWithStyle(BoxStyle style) => GaplyBox(key: key, style: style, child: child);
//
//   @override
//   Widget build(BuildContext context) {
//     Widget result = child;
//
//     final decoration = _buildDecoration(context);
//
//     result = AnimatedContainer(
//       duration: style.duration,
//       curve: style.curve,
//       width: style.layout.width,
//       height: style.layout.height,
//       padding: style.layout.padding,
//       margin: style.layout.margin,
//       alignment: style.layout.alignment,
//       decoration: decoration,
//       clipBehavior: style.layout.borderRadius != null ? Clip.antiAlias : Clip.none,
//       child: result,
//     );
//
//     if (style.shimmer.isEnabled) {
//       result = style.shimmer.buildWidget(context: context, child: result);
//     }
//
//     if (style.blur.isEnabled) {
//       result = style.blur.buildWidget(
//         context: context,
//         borderRadius: style.layout.borderRadius,
//         child: result,
//       );
//     }
//
//     if (style.onPressed != null) {
//       result = TapGestureDetector(
//         onTap: style.onPressed,
//         behavior: HitTestBehavior.opaque,
//         child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
//       );
//     }
//
//     result = style.animations.buildWidget(child: result);
//
//     return result;
//   }
//
//   BoxDecoration? _buildDecoration(BuildContext context) {
//     final hasDecoration =
//         style.color.isEnabled ||
//         style.borderColor.isEnabled ||
//         style.borderWidth > 0 ||
//         style.shadows.isNotEmpty ||
//         style.gradient.isEnabled;
//
//     if (!hasDecoration) return null;
//
//     return BoxDecoration(
//       color: style.color.isVisible ? style.color.resolve(context) : null,
//       borderRadius: style.layout.borderRadius,
//       border: style.borderWidth > 0
//           ? Border.all(
//               color: style.borderColor.resolve(context) ?? Colors.transparent,
//               width: style.borderWidth,
//             )
//           : null,
//       boxShadow: style.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
//       gradient: style.gradient.resolve(context),
//     );
//   }
// }
