part of '../gaply_animation.dart';

@immutable
class FlipParams extends AnimationParams with AnimationParamsWithMixin<FlipParams> {
  final Axis axis;
  final double angleRange;
  final bool isFlipped;
  final Widget? backWidget;

  const FlipParams({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.axis,
    this.angleRange = math.pi,
    required this.isFlipped,
    this.backWidget,
  }) : assert(angleRange > 0 && angleRange <= 2 * math.pi, 'angleRange은 0~2π 범위여야 합니다'),
       super(internalComplete: null);

  const FlipParams._internal({
    required super.duration,
    required super.curve,
    required super.delay,
    required super.onComplete,
    required super.internalComplete,
    required this.axis,
    required this.angleRange,
    required this.isFlipped,
    required this.backWidget,
  });

  const FlipParams.none() : this(duration: Duration.zero, axis: Axis.horizontal, isFlipped: false);

  factory FlipParams.preset(String name, {Widget? backWidget, bool? isFlipped, VoidCallback? onComplete}) {
    final params = GaplyFlipPreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown flip preset: "$name"');
    }
    return params.copyWith(isFlipped: isFlipped, backWidget: backWidget, onComplete: onComplete);
  }

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return FlipTrigger(
      front: child,
      back: backWidget ?? child,
      trigger: trigger ?? DateTime.now(),
      params: this,
    );
  }

  @override
  FlipParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    Axis? axis,
    double? angleRange,
    bool? isFlipped,
    Widget? backWidget,
  }) {
    return FlipParams._internal(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      internalComplete: _internalComplete,
      delay: delay ?? this.delay,
      axis: axis ?? this.axis,
      angleRange: angleRange ?? this.angleRange,
      isFlipped: isFlipped ?? this.isFlipped,
      backWidget: backWidget ?? this.backWidget,
    );
  }

  FlipParams copyWithInternal({VoidCallback? internalComplete}) {
    return FlipParams._internal(
      duration: duration,
      curve: curve,
      delay: delay,
      onComplete: onComplete,
      internalComplete: internalComplete ?? _internalComplete, // 새로운 내부 콜백 주입
      axis: axis,
      angleRange: angleRange,
      isFlipped: isFlipped,
      backWidget: backWidget,
    );
  }

  @override
  FlipParams lerp(AnimationParams? other, double t) {
    if (other is! FlipParams) return this;

    return FlipParams._internal(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      internalComplete: other._internalComplete,
      delay: t < 0.5 ? delay : other.delay,
      axis: t < 0.5 ? axis : other.axis,
      angleRange: lerpDouble(angleRange, other.angleRange, t) ?? angleRange,
      isFlipped: t < 0.5 ? isFlipped : other.isFlipped,
      backWidget: t < 0.5 ? backWidget : other.backWidget,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, angleRange, isFlipped, backWidget];
}

extension FlipParamsX on FlipParams {}

extension FlipParamsExtension on Widget {
  Widget withFlip(FlipParams params, {Widget? back}) {
    if (back == null) {
      return params.buildWidget(child: this);
    }

    return params.copyWith(backWidget: back).buildWidget(child: this);
  }
}

class GaplyFlipPreset with GaplyPreset<FlipParams> {
  static final GaplyFlipPreset instance = GaplyFlipPreset._internal();
  GaplyFlipPreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'vertical',
      const FlipParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        axis: Axis.vertical,
        isFlipped: true,
      ),
    );
    add(
      'horizontal',
      const FlipParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        axis: Axis.horizontal,
        isFlipped: true,
      ),
    );
  }

  static void register(String name, FlipParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static FlipParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
