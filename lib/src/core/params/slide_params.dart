import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/widget/slide_widget.dart';

import '../base/animation_params.dart';

@immutable
class SlideParams extends AnimationParams with DirectionAnimationParamsMixin {
  @override
  final AxisDirection direction;
  final bool visible;
  final bool fixedSize;
  final bool useOpacity;

  const SlideParams({
    super.duration,
    super.curve,
    super.onComplete,
    this.direction = AxisDirection.down,
    this.visible = true,
    this.fixedSize = false,
    this.useOpacity = true,
  });

  factory SlideParams.preset(
    String name, {
    required AxisDirection direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    final params = GaplySlidePreset.of(name) ?? GaplySlidePreset.of('none')!;
    return params.copyWith(
      direction: direction,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  factory SlideParams.fast(
    String name, {
    required AxisDirection direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    final params = GaplySlidePreset.of(name) ?? GaplySlidePreset.of('none')!;
    return params.copyWith(
      duration: Duration(milliseconds: 300),
      direction: direction,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  factory SlideParams.slow(
    String name, {
    required AxisDirection direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    final params = GaplySlidePreset.of(name) ?? GaplySlidePreset.of('none')!;
    return params.copyWith(
      duration: Duration(milliseconds: 800),
      direction: direction,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  factory SlideParams.elastic(
    AxisDirection direction, {
    Duration duration = const Duration(milliseconds: 400),
    bool visible = true,
    bool fixedSize = false,
    bool useOpacity = true,
  }) {
    return SlideParams(
      direction: direction,
      duration: duration,
      curve: Curves.elasticOut,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  factory SlideParams.bounce(
    AxisDirection direction, {
    Duration duration = const Duration(milliseconds: 500),
    bool visible = true,
    bool fixedSize = false,
    bool useOpacity = true,
  }) {
    return SlideParams(
      direction: direction,
      duration: duration,
      curve: Curves.bounceOut,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  SlideParams get reversed {
    return copyWith(direction: reversedDirection);
  }

  @override
  List<Object?> get props => [...super.props, visible, fixedSize, useOpacity];

  @override
  SlideParams copyWith({
    AxisDirection? direction,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    return SlideParams(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      visible: visible ?? this.visible,
      fixedSize: fixedSize ?? this.fixedSize,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  @override
  SlideParams lerp(AnimationParams? other, double t) {
    if (other is! SlideParams) return this;
    return SlideParams(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      direction: t < 0.5 ? direction : other.direction,
      visible: t < 0.5 ? visible : other.visible,
      fixedSize: t < 0.5 ? fixedSize : other.fixedSize,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }

  Widget buildWidget({required Widget child}) {
    return SlideWidget(params: this, child: child);
  }
}

extension SlideParamsExtension on Widget {
  Widget withSlide(SlideParams params) => SlideWidget(params: params, child: this);
}

class GaplySlidePreset with GaplyPreset<SlideParams> {
  static final GaplySlidePreset instance = GaplySlidePreset._internal();
  GaplySlidePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;
    add('none', const SlideParams(duration: Duration.zero));
    add('left', const SlideParams(direction: AxisDirection.left));
    add('right', const SlideParams(direction: AxisDirection.right));
    add('up', const SlideParams(direction: AxisDirection.up));
    add('down', const SlideParams(direction: AxisDirection.down));
  }

  static void register(String name, SlideParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static SlideParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
