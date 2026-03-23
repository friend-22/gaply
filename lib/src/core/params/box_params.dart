import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/shadow_params.dart';
import 'package:gaply/src/core/params/shimmer_params.dart';
import 'package:gaply/src/widget/tap_gesture_detector.dart';

import 'animation_sequence_params.dart';
import 'blur_params.dart';
import 'color_params.dart';
import 'gradient_params.dart';
import 'layout_params.dart';

@immutable
class BoxParams extends ParamsBase<BoxParams> {
  // 1. Layout & Shape
  final LayoutParams layout;

  // 2. Static Style
  final ColorParams color;
  final ColorParams borderColor;
  final double borderWidth;
  final List<ShadowParams> shadows;
  final BlurParams blur;
  final GradientParams gradient;

  // 3. Dynamic Effects
  final ShimmerParams shimmer;
  final AnimationSequenceParams animation;

  // 4. button Style
  final VoidCallback? onPressed;
  final Curve curve;
  final Duration duration;

  const BoxParams({
    this.layout = const LayoutParams.none(),
    this.color = const ColorParams.none(),
    this.borderColor = const ColorParams.none(),
    this.borderWidth = 0.0,
    this.shadows = const [],
    this.blur = const BlurParams.none(),
    this.gradient = const GradientParams.none(),
    this.shimmer = const ShimmerParams.none(),
    this.animation = const AnimationSequenceParams.none(),
    this.onPressed,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
  });

  factory BoxParams.preset(String name) {
    final params = GaplyBoxPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown box preset: "$name"');
    }
    return params;
  }

  @override
  bool get isEnabled {
    return layout.isEnabled;
  }

  @override
  BoxParams copyWith({
    LayoutParams? layout,

    ColorParams? color,
    ColorParams? borderColor,
    double? borderWidth,
    List<ShadowParams>? shadows,
    BlurParams? blur,
    GradientParams? gradient,
    ShimmerParams? shimmer,
    AnimationSequenceParams? animation,
    VoidCallback? onPressed,
    Duration? duration,
    Curve? curve,
  }) {
    return BoxParams(
      layout: layout ?? this.layout,
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadows: shadows ?? this.shadows,
      blur: blur ?? this.blur,
      gradient: gradient ?? this.gradient,
      shimmer: shimmer ?? this.shimmer,
      animation: animation ?? this.animation,

      // useFocusOutline: useFocusOutline ?? this.useFocusOutline,
      // focused: focused ?? this.focused,
      // center: center ?? this.center,
      onPressed: onPressed ?? this.onPressed,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  @override
  BoxParams lerp(BoxParams? other, double t) {
    if (other == null) return this;
    return copyWith(
      layout: layout.lerp(other.layout, t),
      color: color.lerp(other.color, t),
      borderColor: borderColor.lerp(other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
      shadows: _lerpShadowList(shadows, other.shadows, t),
      blur: blur.lerp(other.blur, t),
      gradient: gradient.lerp(other.gradient, t),
      shimmer: shimmer.lerp(other.shimmer, t),
      animation: animation.lerp(other.animation, t),
      onPressed: t < 0.5 ? onPressed : other.onPressed,
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
    );
  }

  List<ShadowParams> _lerpShadowList(List<ShadowParams> a, List<ShadowParams> b, double t) {
    return t < 0.5 ? a : b;
  }

  @override
  List<Object?> get props => [
    layout,
    color,
    borderColor,
    borderWidth,
    shadows,
    blur,
    gradient,
    shimmer,
    animation,
    onPressed,
    duration,
    curve,
  ];
}

mixin BoxParamsMixin {
  BoxParams get params;

  Widget buildBox(BuildContext context, Widget content) {
    Widget result = content;

    // if (params.blur.isEnabled) {
    //   print('DEBUG: Applying blur');
    //   //result = ImageFiltered(imageFilter: params.blur.resolve()!, child: result);
    //   result = Stack(
    //     children: [
    //       // 1. 흐려진 배경
    //       Positioned.fill(
    //         child: ClipRRect(
    //           borderRadius: params.borderRadius ?? BorderRadius.zero,
    //           //child: Container(color: Colors.red),
    //           child: BackdropFilter(filter: params.blur.resolve()!, child: const SizedBox()),
    //         ),
    //       ),
    //       result,
    //       // 2. 선명한 콘텐츠
    //     ],
    //   );
    //   print('DEBUG: Blur applied');
    // }

    final decoration = _buildDecoration(context);

    result = AnimatedContainer(
      duration: params.duration,
      curve: params.curve,
      width: params.layout.width,
      height: params.layout.height,
      padding: params.layout.padding,
      margin: params.layout.margin,
      alignment: params.layout.alignment,
      decoration: decoration,
      clipBehavior: params.layout.borderRadius != null ? Clip.antiAlias : Clip.none,
      child: result,
    );

    if (params.shimmer.isEnabled) {
      result = params.shimmer.buildWidget(context: context, child: result);
    }

    if (params.blur.isEnabled) {
      result = params.blur.buildWidget(
        context: context,
        borderRadius: params.layout.borderRadius,
        child: result,
      );
    }

    if (params.onPressed != null) {
      result = TapGestureDetector(
        onTap: params.onPressed,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: result),
      );
    }

    return result;
  }

  BoxDecoration? _buildDecoration(BuildContext context) {
    final hasDecoration =
        params.color.isEnabled ||
        params.borderColor.isEnabled ||
        params.borderWidth > 0 ||
        params.shadows.isNotEmpty ||
        params.gradient.isEnabled;

    if (!hasDecoration) return null;

    return BoxDecoration(
      color: params.color.isVisible ? params.color.resolve(context) : null,
      borderRadius: params.layout.borderRadius,
      border: params.borderWidth > 0
          ? Border.all(
              color: params.borderColor.resolve(context) ?? Colors.transparent,
              width: params.borderWidth,
            )
          : null,
      boxShadow: params.shadows.map((s) => s.resolve(context)).whereType<BoxShadow>().toList(),
      gradient: params.gradient.resolve(context),
    );
  }
}

class GaplyBoxPreset with GaplyPreset<BoxParams> {
  static final GaplyBoxPreset instance = GaplyBoxPreset._internal();
  GaplyBoxPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('rainbow', BoxParams(gradient: GradientParams.preset('rainbow')));

    add(
      'card',
      const BoxParams(
        layout: LayoutParams(
          padding: EdgeInsets.all(16),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: ColorParams(role: ColorRole.surface),
        shadows: [
          // ShadowParams.preset('small')
        ],
      ),
    );

    add(
      'button',
      const BoxParams(
        layout: LayoutParams(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: ColorParams(role: ColorRole.primary),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  static void register(String name, BoxParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static BoxParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
