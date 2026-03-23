part of '../gaply_animation.dart';

@immutable
class FadeParams extends AnimationParams with AnimationParamsWithMixin<FadeParams> {
  final bool visible;

  const FadeParams({super.duration, super.curve, super.onComplete, super.delay, required this.visible})
    : super(internalComplete: null);

  const FadeParams._internal({
    required super.duration,
    required super.curve,
    required super.delay,
    required super.onComplete,
    required super.internalComplete,
    required this.visible,
  });

  const FadeParams.none() : this(duration: Duration.zero, visible: false);

  factory FadeParams.preset(String name, {VoidCallback? onComplete}) {
    final params = GaplyFadePreset.of(name);

    if (params == null) {
      throw ArgumentError('Unknown fade preset: "$name"');
    }

    return (onComplete != null) ? params.copyWith(onComplete: onComplete) : params;
  }

  @override
  Widget buildWidget({required Widget child, Object? trigger}) {
    return FadeTrigger(params: this, trigger: trigger ?? DateTime.now(), child: child);
  }

  @override
  FadeParams copyWith({
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
    Duration? delay,
    bool? visible,
  }) {
    return FadeParams._internal(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      onComplete: onComplete ?? this.onComplete,
      internalComplete: _internalComplete,
      delay: delay ?? this.delay,
      visible: visible ?? this.visible,
    );
  }

  FadeParams copyWithInternal({VoidCallback? internalComplete}) {
    return FadeParams._internal(
      duration: duration,
      curve: curve,
      delay: delay,
      onComplete: onComplete,
      internalComplete: internalComplete ?? _internalComplete,
      visible: visible,
    );
  }

  @override
  FadeParams lerp(AnimationParams? other, double t) {
    if (other is! FadeParams) return this;

    return FadeParams._internal(
      duration: t < 0.5 ? duration : other.duration,
      curve: t < 0.5 ? curve : other.curve,
      onComplete: other.onComplete,
      internalComplete: other._internalComplete,
      delay: t < 0.5 ? delay : other.delay,
      visible: t < 0.5 ? visible : other.visible,
    );
  }

  @override
  List<Object?> get props => [...super.props, visible];
}

extension FadeParamsX on FadeParams {}

extension FadeParamsExtension on Widget {
  Widget withFade(FadeParams params) => params.buildWidget(child: this);
}

class GaplyFadePreset with GaplyPreset<FadeParams> {
  static final GaplyFadePreset instance = GaplyFadePreset._internal();
  GaplyFadePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add(
      'fadeIn',
      const FadeParams(duration: Duration(milliseconds: 500), curve: Curves.easeInOut, visible: true),
    );
    add(
      'fadeOut',
      const FadeParams(duration: Duration(milliseconds: 500), curve: Curves.easeOut, visible: false),
    );
  }

  static void register(String name, FadeParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static FadeParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
