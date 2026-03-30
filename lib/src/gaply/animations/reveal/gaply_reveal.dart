import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_direction.dart';
import 'package:gaply/src/gaply/animations/fade/gaply_fade.dart';
import 'package:gaply/src/gaply/animations/size/size_style.dart';
import 'package:gaply/src/gaply/animations/motion/gaply_motion.dart';

import 'gaply_reveal_modifier.dart';

part 'gaply_reveal.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyReveal extends GaplyAnimStyle<GaplyReveal>
    with
        GaplyTweenMixin<GaplyReveal>,
        GaplyAnimMixin<GaplyReveal>,
        GaplyDirectionAnimMixin,
        _RevealStyleMixin,
        GaplyRevealModifier<GaplyReveal> {
  @override
  final AxisDirection direction;
  final bool isVisible;
  final bool fixedSize;
  final bool useFade;

  const GaplyReveal({
    super.profiler,
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

  const GaplyReveal.none() : this(duration: Duration.zero, direction: AxisDirection.up, isVisible: false);

  static GaplyRevealPreset preset = GaplyRevealPreset._i;

  factory GaplyReveal.of(
    Object key, {
    GaplyProfiler? profiler,
    bool? isVisible,
    bool? fixedSize,
    bool? useFade,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(
      profiler: profiler,
      isVisible: isVisible,
      fixedSize: fixedSize,
      useFade: useFade,
      onComplete: onComplete,
    );
  }

  const GaplyReveal.up({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.up,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const GaplyReveal.down({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.down,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const GaplyReveal.left({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         direction: AxisDirection.left,
         isVisible: isVisible,
         fixedSize: fixedSize,
         useFade: useFade,
       );

  const GaplyReveal.right({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    bool isVisible = true,
    bool fixedSize = false,
    bool useFade = true,
  }) : this(
         profiler: profiler,
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
  GaplyReveal copyWith({
    GaplyProfiler? profiler,
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
    return GaplyReveal(
      profiler: profiler ?? this.profiler,
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
  GaplyReveal lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplyReveal) return this;

    return profiler.trace(() {
      return GaplyReveal(
        profiler: other.profiler,
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
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, direction, isVisible, fixedSize, useFade];

  @override
  bool get hasEffect => duration.inMilliseconds > 0;
}

mixin _RevealStyleMixin {
  GaplyReveal get _self => this as GaplyReveal;
  GaplyReveal get gaplyReveal => _self;

  GaplyReveal copyWithReveal(GaplyReveal reveal) {
    return _self.copyWith(
      profiler: reveal.profiler,
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
    if (!_self.hasEffect) return child;

    return _self.profiler.trace(() {
      final List<GaplyAnimStyle> animations = [];
      if (_self.useFade) animations.add(_fade);
      if (!_self.fixedSize) animations.add(_size);

      return GaplyMotion(
        animations: animations,
        onComplete: _self.onComplete,
      ).buildWidget(child: child, trigger: trigger ?? DateTime.now());
    }, tag: 'buildWidget');
  }

  GaplyFade get _fade => GaplyFade(
    duration: _self.duration,
    curve: _self.curve,
    isVisible: _self.useFade ? _self.isVisible : true,
    delay: _self.delay,
  );

  SizeStyle get _size => SizeStyle(
    duration: _self.duration,
    curve: _self.curve,
    axis: _self.axis,
    axisAlignment: (_self.direction == AxisDirection.up || _self.direction == AxisDirection.left)
        ? 1.0
        : -1.0,
    isExpanded: _self.fixedSize ? true : _self.isVisible,
    delay: _self.delay,
  );
}

void _initPresets(GaplyRevealPreset preset) {
  preset.add(
    'drop',
    const GaplyReveal(direction: AxisDirection.down, isVisible: true, useFade: true, fixedSize: false),
  );

  preset.add(
    'rise',
    const GaplyReveal(direction: AxisDirection.up, isVisible: true, useFade: true, fixedSize: false),
  );

  preset.add(
    'expandRight',
    const GaplyReveal(direction: AxisDirection.right, isVisible: true, useFade: true, fixedSize: false),
  );

  preset.add(
    'fadeIn',
    const GaplyReveal(
      direction: AxisDirection.down,
      isVisible: true,
      useFade: true,
      fixedSize: true,
      duration: Duration(milliseconds: 300),
    ),
  );

  preset.add(
    'bounce',
    const GaplyReveal(
      direction: AxisDirection.up,
      isVisible: true,
      useFade: true,
      fixedSize: false,
      curve: Curves.elasticOut,
      duration: Duration(milliseconds: 600),
    ),
  );
}
