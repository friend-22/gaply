part of '../gaply_animation.dart';

@immutable
class ScaleParams extends AnimationParams with AnimationParamsWithMixin<ScaleParams> {
  final double begin;
  final double end;
  final Alignment alignment;
  final bool isScaled;

  const ScaleParams({
    super.duration,
    super.curve,
    super.onComplete,
    super.delay,
    required this.begin,
    required this.end,
    this.alignment = Alignment.center,
    required this.isScaled,
  }) : super(internalComplete: null);

  const ScaleParams._internal({
    required super.duration,
    required super.curve,
    required super.delay,
    required super.onComplete,
    required super.internalComplete,
    required this.begin,
    required this.end,
    required this.alignment,
    required this.isScaled,
  });

  const ScaleParams.none()
    : this(
        duration: Duration.zero,
        curve: Curves.linear,
        begin: 0.0,
        end: 1.0,
        alignment: Alignment.center,
        isScaled: false,
      );

  factory ScaleParams.preset(String name, {Alignment? alignment, bool? isScaled, VoidCallback? onComplete}) {
    final params = GaplyScalePreset.of(name);

    if (params == null) {
      throw ArgumentError('Unknown scale preset: "$name"');
    }

    return params.copyWith(alignment: alignment, isScaled: isScaled, onComplete: onComplete);
  }

  @override
  bool get isEnabled => isScaled && duration.inMilliseconds > 0;

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return ScaleTrigger(params: this, trigger: trigger ?? DateTime.now(), child: child);
  }

  @override
  ScaleParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    double? begin,
    double? end,
    Alignment? alignment,
    bool? isScaled,
  }) {
    return ScaleParams._internal(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      internalComplete: _internalComplete,
      delay: delay ?? this.delay,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alignment: alignment ?? this.alignment,
      isScaled: isScaled ?? this.isScaled,
    );
  }

  ScaleParams copyWithInternal({VoidCallback? internalComplete}) {
    return ScaleParams._internal(
      duration: duration,
      curve: curve,
      delay: delay,
      onComplete: onComplete,
      internalComplete: internalComplete ?? _internalComplete,
      begin: begin,
      end: end,
      alignment: alignment,
      isScaled: isScaled,
    );
  }

  @override
  ScaleParams lerp(AnimationParams? other, double t) {
    if (other is! ScaleParams) return this;

    return ScaleParams._internal(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      internalComplete: other._internalComplete,
      delay: t < 0.5 ? delay : other.delay,
      begin: lerpDouble(begin, other.begin, t) ?? begin,
      end: lerpDouble(end, other.end, t) ?? end,
      alignment: Alignment.lerp(alignment, other.alignment, t) ?? alignment,
      isScaled: t < 0.5 ? isScaled : other.isScaled,
    );
  }

  @override
  List<Object?> get props => [...super.props, begin, end, alignment, isScaled];
}

extension ScaleParamsExtension on Widget {
  Widget withScale(ScaleParams params) => params.buildWidget(child: this);
}

class GaplyScalePreset with GaplyPreset<ScaleParams> {
  static final GaplyScalePreset instance = GaplyScalePreset._internal();
  GaplyScalePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'pop',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        begin: 0.0,
        end: 1.1,
        isScaled: true,
      ),
    );
    add(
      'shrink',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        begin: 1.0,
        end: 0.0,
        isScaled: true,
      ),
    );
    add(
      'grow',
      const ScaleParams(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        begin: 0.0,
        end: 1.0,
        isScaled: true,
      ),
    );
  }

  static void register(String name, ScaleParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static ScaleParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
