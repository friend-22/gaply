import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/animations/fade/fade_style.dart';
import 'package:gaply/src/gaply/animations/size/size_style.dart';
import 'package:gaply/src/gaply/animations/motion/gaply_motion.dart';

import 'reveal_presets.dart';
import 'reveal_style_modifier.dart';

@immutable
class RevealStyle extends GaplyAnimStyle<RevealStyle>
    with
        GaplyTweenMixin<RevealStyle>,
        GaplyAnimMixin<RevealStyle>,
        GaplyDirectionAnimMixin,
        _RevealStyleMixin,
        RevealStyleModifier<RevealStyle> {
  @override
  final AxisDirection direction;
  final bool isVisible;
  final bool fixedSize;
  final bool useFade;

  const RevealStyle({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.direction,
    required this.isVisible,
    this.fixedSize = false,
    this.useFade = true,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const RevealStyle.none() : this(duration: Duration.zero, direction: AxisDirection.up, isVisible: false);

  static void register(String name, RevealStyle style) => GaplyRevealPreset.register(name, style);

  factory RevealStyle.preset(
    String name, {
    bool? isVisible,
    bool? fixedSize,
    bool? useFade,
    VoidCallback? onComplete,
  }) {
    final style = GaplyRevealPreset.of(name);
    if (style == null) {
      throw ArgumentError(GaplyRevealPreset.instance.errorMessage("RevealStyle", name));
    }
    return style.copyWith(
      isVisible: isVisible,
      fixedSize: fixedSize,
      useFade: useFade,
      onComplete: onComplete,
    );
  }

  const RevealStyle.up({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.up,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const RevealStyle.down({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.down,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const RevealStyle.left({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.left,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const RevealStyle.right({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.right,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  @override
  RevealStyle copyWith({
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    AxisDirection? direction,
    bool? isVisible,
    bool? fixedSize,
    bool? useFade,
  }) {
    return RevealStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      direction: direction ?? this.direction,
      isVisible: isVisible ?? this.isVisible,
      fixedSize: fixedSize ?? this.fixedSize,
      useFade: useFade ?? this.useFade,
    );
  }

  @override
  RevealStyle lerp(GaplyAnimStyle? other, double t) {
    if (other is! RevealStyle) return this;

    return RevealStyle(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      delay: t < 0.5 ? delay : other.delay,
      onComplete: other.onComplete,
      progress: lerpDouble(progress, other.progress, t) ?? other.progress,
      direction: t < 0.5 ? direction : other.direction,
      isVisible: t < 0.5 ? isVisible : other.isVisible,
      fixedSize: t < 0.5 ? fixedSize : other.fixedSize,
      useFade: t < 0.5 ? useFade : other.useFade,
    );
  }

  @override
  List<Object?> get props => [...super.props, direction, isVisible, fixedSize, useFade];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _RevealStyleMixin {
  RevealStyle get revealStyle => this as RevealStyle;

  RevealStyle copyWithReveal(RevealStyle reveal) {
    return revealStyle.copyWith(
      duration: reveal.duration,
      curve: reveal.curve,
      delay: reveal.delay,
      onComplete: reveal.onComplete,
      progress: reveal.progress,
      direction: reveal.direction,
      isVisible: reveal.isVisible,
      fixedSize: reveal.fixedSize,
      useFade: reveal.useFade,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!revealStyle.hasEffect) return child;

    final List<GaplyAnimStyle> animations = [];
    if (revealStyle.useFade) animations.add(_fade);
    if (!revealStyle.fixedSize) animations.add(_size);

    return GaplyMotion(
      animations: animations,
      onComplete: revealStyle.onComplete,
    ).buildWidget(child: child, trigger: trigger ?? DateTime.now());
  }

  FadeStyle get _fade => FadeStyle(
    duration: revealStyle.duration,
    curve: revealStyle.curve,
    isVisible: revealStyle.useFade ? revealStyle.isVisible : true,
    delay: revealStyle.delay,
  );

  SizeStyle get _size => SizeStyle(
    duration: revealStyle.duration,
    curve: revealStyle.curve,
    axis: revealStyle.axis,
    axisAlignment: (revealStyle.direction == AxisDirection.up || revealStyle.direction == AxisDirection.left)
        ? 1.0
        : -1.0,
    isExpanded: revealStyle.fixedSize ? true : revealStyle.isVisible,
    delay: revealStyle.delay,
  );
}
