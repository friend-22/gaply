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
    required this.direction,
    this.visible = true,
    this.fixedSize = false,
    this.useOpacity = true,
  });

  const SlideParams.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, visible: false);

  factory SlideParams.preset(
    String name, {
    required AxisDirection direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    final params = GaplySlidePreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown slide preset: "$name"');
    }
    return params.copyWith(
      direction: direction,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  SlideParams withSpeed(double speed) {
    final resolveDuration = duration.inMilliseconds * speed;
    return copyWith(duration: Duration(milliseconds: resolveDuration.toInt()));
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
    return SlideTrigger(params: this, trigger: DateTime.now(), child: child);
  }
}

extension SlideParamsExtension on Widget {
  Widget withSlide(SlideParams params) => SlideTrigger(params: params, trigger: DateTime.now(), child: this);
}

class GaplySlidePreset with GaplyPreset<SlideParams> {
  static final GaplySlidePreset instance = GaplySlidePreset._internal();
  GaplySlidePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'left',
      const SlideParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.left,
      ),
    );
    add(
      'right',
      const SlideParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.right,
      ),
    );
    add(
      'up',
      const SlideParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.up,
      ),
    );
    add(
      'down',
      const SlideParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        direction: AxisDirection.down,
      ),
    );
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
