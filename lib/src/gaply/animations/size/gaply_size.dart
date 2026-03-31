import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply_base.dart';

import 'size_widget.dart';
import 'gaply_size_modifier.dart';

part 'size_trigger.dart';
part 'gaply_size.preset.g.dart';

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplySize extends GaplyAnimStyle<GaplySize>
    with
        GaplyTweenMixin<GaplySize>,
        GaplyAnimMixin<GaplySize>,
        _SizeStyleMixin,
        GaplySizeModifier<GaplySize> {
  final Axis axis;
  final double axisAlignment;
  final bool isExpanded;
  final double minFactor;

  const GaplySize({
    super.profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    super.onComplete,
    super.progress,
    required this.axis,
    required this.isExpanded,
    this.minFactor = 0.0,
    this.axisAlignment = -1.0,
  }) : super(
         duration: duration ?? const Duration(milliseconds: 400),
         curve: curve ?? Curves.easeOutCubic,
         delay: delay ?? Duration.zero,
       );

  const GaplySize.none() : this(duration: Duration.zero, axis: Axis.vertical, isExpanded: false);

  static GaplySizePreset preset = GaplySizePreset._i;

  factory GaplySize.of(
    Object key, {
    GaplyProfiler? profiler,
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
    VoidCallback? onComplete,
  }) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }

    return style.copyWith(
      profiler: profiler,
      axisAlignment: axisAlignment,
      isExpanded: isExpanded,
      minFactor: minFactor,
      onComplete: onComplete,
    );
  }

  const GaplySize.left({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const GaplySize.right({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const GaplySize.up({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const GaplySize.down({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: -1.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const GaplySize.vertical({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.vertical,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  const GaplySize.horizontal({
    GaplyProfiler? profiler,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
    bool isExpanded = true,
    double minFactor = 0.0,
  }) : this(
         profiler: profiler,
         duration: duration,
         curve: curve,
         delay: delay,
         onComplete: onComplete,
         axis: Axis.horizontal,
         axisAlignment: 0.0,
         isExpanded: isExpanded,
         minFactor: minFactor,
       );

  @override
  GaplySize copyWith({
    GaplyProfiler? profiler,
    Duration? duration,
    Curve? curve,
    Duration? delay,
    VoidCallback? onComplete,
    double? progress,
    Axis? axis,
    double? axisAlignment,
    bool? isExpanded,
    double? minFactor,
  }) {
    return GaplySize(
      profiler: profiler ?? this.profiler,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      delay: delay ?? this.delay,
      onComplete: onComplete ?? this.onComplete,
      progress: progress ?? this.progress,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      isExpanded: isExpanded ?? this.isExpanded,
      minFactor: minFactor ?? this.minFactor,
    );
  }

  @override
  GaplySize lerp(GaplyAnimStyle? other, double t) {
    if (other is! GaplySize) return this;

    return profiler.trace(() {
      return GaplySize(
        profiler: other.profiler,
        duration: t < 0.5 ? duration : other.duration,
        curve: t < 0.5 ? curve : other.curve,
        delay: t < 0.5 ? delay : other.delay,
        onComplete: other.onComplete,
        progress: lerpDouble(progress, other.progress, t) ?? other.progress,
        axis: t < 0.5 ? axis : other.axis,
        axisAlignment: lerpDouble(axisAlignment, other.axisAlignment, t) ?? axisAlignment,
        isExpanded: t < 0.5 ? isExpanded : other.isExpanded,
        minFactor: lerpDouble(minFactor, other.minFactor, t) ?? minFactor,
      );
    }, tag: 'lerp');
  }

  @override
  List<Object?> get props => [...super.props, axis, axisAlignment, isExpanded, minFactor];

  @override
  bool get hasEffect => duration.inMilliseconds > 0 || target < 1.0;

  double get target => isExpanded ? 1.0 : minFactor;
}

mixin _SizeStyleMixin {
  GaplySize get _self => this as GaplySize;
  GaplySize get gaplySize => _self;

  GaplySize copyWithSize(GaplySize size) {
    return _self.copyWith(
      profiler: size.profiler,
      duration: size.duration,
      curve: size.curve,
      delay: size.delay,
      onComplete: size.onComplete,
      progress: size.progress,
      axis: size.axis,
      axisAlignment: size.axisAlignment,
      isExpanded: size.isExpanded,
      minFactor: size.minFactor,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    if (!_self.hasEffect) return child;

    return _GaplySizeTrigger(style: _self, trigger: trigger ?? DateTime.now(), child: child);
  }
}

void _addByDirection(
  GaplySizePreset preset,
  Object key,
  AxisDirection dir, {
  Duration? duration,
  Curve? curve,
}) {
  final bool isVertical = dir == AxisDirection.up || dir == AxisDirection.down;

  final bool isReversed = dir == AxisDirection.up || dir == AxisDirection.left;
  final double alignment = isReversed ? 1.0 : -1.0;

  preset.add(
    key,
    GaplySize(
      duration: duration ?? const Duration(milliseconds: 400),
      curve: curve ?? Curves.easeOutCubic,
      axis: isVertical ? Axis.vertical : Axis.horizontal,
      axisAlignment: alignment,
      isExpanded: true,
    ),
  );
}

void _initPresets(GaplySizePreset preset) {
  _addByDirection(
    preset,
    'popIn',
    AxisDirection.up,
    duration: const Duration(milliseconds: 600),
    curve: Curves.elasticOut,
  );

  _addByDirection(
    preset,
    'softUp',
    AxisDirection.up,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutQuad,
  );

  preset.add(
    'exitRight',
    GaplySize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
      axis: Axis.horizontal,
      axisAlignment: -1.0,
      isExpanded: false,
    ),
  );
}
