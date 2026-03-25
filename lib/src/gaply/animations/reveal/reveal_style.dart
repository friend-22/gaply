import 'package:flutter/widgets.dart';
import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/animations/animations.dart';

import 'reveal_presets.dart';

@immutable
class RevealStyle extends GaplyAnimStyle with GaplyAnimMixin<RevealStyle>, GaplyDirectionAnimMixin {
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
      throw ArgumentError(
        'Unknown reveal preset: "$name". '
        'Available presets: ${GaplyRevealPreset.instance.allKeys.join(", ")}',
      );
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
    VoidCallback? onComplete,
    Duration? delay,
    AxisDirection? direction,
    bool? isVisible,
    bool? fixedSize,
    bool? useFade,
  }) {
    return RevealStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      delay: delay ?? this.delay,
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
      onComplete: other.onComplete,
      delay: t < 0.5 ? delay : other.delay,
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

  FadeStyle get _fade =>
      FadeStyle(duration: duration, curve: curve, isVisible: useFade ? isVisible : true, delay: delay);

  SizeStyle get _size => SizeStyle(
    duration: duration,
    curve: curve,
    axis: axis,
    axisAlignment: (direction == AxisDirection.up || direction == AxisDirection.left) ? 1.0 : -1.0,
    isExpanded: fixedSize ? true : isVisible,
    delay: delay,
  );

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!hasEffect) return child;

    final List<GaplyAnimStyle> animations = [];
    if (useFade) animations.add(_fade);
    if (!fixedSize) animations.add(_size);

    return GaplyMotion(
      animations: animations,
      onComplete: onComplete,
    ).buildWidget(child: child, trigger: trigger ?? DateTime.now());
  }
}
