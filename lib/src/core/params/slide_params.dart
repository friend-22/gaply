part of '../gaply_animation.dart';

@immutable
class SlideParams extends AnimationParams
    with AnimationParamsWithMixin<SlideParams>, DirectionAnimationParamsMixin {
  @override
  final AxisDirection direction;
  final bool visible;
  final bool fixedSize;
  final bool useOpacity;

  const SlideParams({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.direction,
    this.visible = true,
    this.fixedSize = false,
    this.useOpacity = true,
  }) : super(internalComplete: null);

  const SlideParams._internal({
    required super.duration,
    required super.curve,
    required super.delay,
    required super.onComplete,
    required super.internalComplete,
    required this.direction,
    required this.visible,
    required this.fixedSize,
    required this.useOpacity,
  });

  const SlideParams.none()
    : this(duration: Duration.zero, curve: Curves.linear, direction: AxisDirection.down, visible: false);

  factory SlideParams.preset(
    String name, {
    AxisDirection? direction,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
    VoidCallback? onComplete,
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
      onComplete: onComplete,
    );
  }

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return SlideTrigger(params: this, trigger: trigger ?? DateTime.now(), child: child);
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
    Duration? delay,
    bool? visible,
    bool? fixedSize,
    bool? useOpacity,
  }) {
    return SlideParams._internal(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      internalComplete: _internalComplete,
      delay: delay ?? this.delay,
      visible: visible ?? this.visible,
      fixedSize: fixedSize ?? this.fixedSize,
      useOpacity: useOpacity ?? this.useOpacity,
    );
  }

  SlideParams copyWithInternal({VoidCallback? internalComplete}) {
    return SlideParams._internal(
      direction: direction,
      duration: duration,
      curve: curve,
      delay: delay,
      onComplete: onComplete,
      internalComplete: internalComplete ?? _internalComplete,
      visible: visible,
      fixedSize: fixedSize,
      useOpacity: useOpacity,
    );
  }

  @override
  SlideParams lerp(AnimationParams? other, double t) {
    if (other is! SlideParams) return this;

    return SlideParams._internal(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      internalComplete: other._internalComplete,
      delay: t < 0.5 ? delay : other.delay,
      direction: t < 0.5 ? direction : other.direction,
      visible: t < 0.5 ? visible : other.visible,
      fixedSize: t < 0.5 ? fixedSize : other.fixedSize,
      useOpacity: t < 0.5 ? useOpacity : other.useOpacity,
    );
  }
}

extension SlideParamsExtension on Widget {
  Widget withSlide(SlideParams params) => params.buildWidget(child: this);
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
