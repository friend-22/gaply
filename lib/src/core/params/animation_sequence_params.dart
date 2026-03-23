part of '../gaply_animation.dart';

@immutable
class AnimationSequenceParams extends ParamsBase<AnimationSequenceParams> with AnimationSequenceParamsMixin {
  final List<AnimationParams> effects;
  final List<AnimationSequenceParams> children;
  final VoidCallback? onComplete;

  const AnimationSequenceParams({required this.effects, this.children = const [], this.onComplete});

  const AnimationSequenceParams.none() : this(effects: const []);

  factory AnimationSequenceParams.preset(String name) {
    final params = GaplyAnimationSequencePreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown animation sequence preset: "$name"');
    }
    return params;
  }

  @override
  bool get isEnabled => effects.isNotEmpty || children.isNotEmpty;

  AnimationSequenceParams addEffect(AnimationParams effect) {
    return copyWith(effects: [...effects, effect]);
  }

  AnimationSequenceParams addEffects(List<AnimationParams> newEffects) {
    return copyWith(effects: [...effects, ...newEffects]);
  }

  @override
  AnimationSequenceParams lerp(AnimationSequenceParams? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    return applyAnimationSequence(this, child, trigger: trigger);
  }

  @override
  AnimationSequenceParams copyWith({
    List<AnimationParams>? effects,
    List<AnimationSequenceParams>? children,
    VoidCallback? onComplete,
  }) {
    return AnimationSequenceParams(
      effects: effects ?? this.effects,
      children: children ?? this.children,
      onComplete: onComplete ?? this.onComplete,
    );
  }

  @override
  List<Object?> get props => [effects, children, onComplete];

  Duration get effectsDuration {
    if (effects.isEmpty) return Duration.zero;
    return effects.fold<Duration>(Duration.zero, (sum, e) => sum + e.duration + e.delay);
  }
}

/// AnimationSequenceParams를 Widget에 적용하는 확장 메서드
mixin AnimationSequenceParamsMixin {
  Widget applyAnimationSequence(AnimationSequenceParams params, Widget child, {Object? trigger}) {
    if (!params.isEnabled) return child;

    Widget result = child;

    for (int i = 0; i < params.effects.length; i++) {
      var effect = params.effects[i];

      if (i == params.effects.length - 1 && params.children.isEmpty) {
        effect = (effect as AnimationParamsWithMixin)._copyWithInternal(params.onComplete);
      }

      result = _wrapWithEffect(result, effect, trigger: trigger);
    }

    if (params.children.isNotEmpty) {
      final delayAfterEffects = params.effectsDuration;

      List<Widget> sequenceLayers = [result];

      for (int i = 0; i < params.children.length; i++) {
        var childSeq = params.children[i];

        if (i == params.children.length - 1) {
          childSeq = childSeq.copyWith(onComplete: params.onComplete);
        }

        final delayedEffects = childSeq.effects.map((e) {
          return e.withDelay(delayAfterEffects);
        }).toList();

        final childLayer = applyAnimationSequence(
          childSeq.copyWith(effects: delayedEffects),
          result,
          trigger: trigger,
        );

        sequenceLayers.add(childLayer);
      }

      result = Stack(alignment: Alignment.center, children: sequenceLayers);
    }

    return result;
  }

  Widget _wrapWithEffect(Widget child, AnimationParams effect, {Object? trigger}) {
    return switch (effect) {
      FadeParams p => p.buildWidget(child: child, trigger: trigger),
      ShakeParams p => p.buildWidget(child: child, trigger: trigger),
      SlideParams p => p.buildWidget(child: child, trigger: trigger),
      ScaleParams p => p.buildWidget(child: child, trigger: trigger),
      FlipParams p => p.buildWidget(child: child, trigger: trigger),
      _ => child,
    };
  }
}

class GaplyAnimationSequencePreset with GaplyPreset<AnimationSequenceParams> {
  static final GaplyAnimationSequencePreset instance = GaplyAnimationSequencePreset._internal();
  GaplyAnimationSequencePreset._internal();

  void _ensureInitialized() {
    if (hasPreset) return;

    add('none', const AnimationSequenceParams.none());

    add(
      'error',
      AnimationSequenceParams(
        effects: [ShakeParams.preset('severe'), FadeParams.preset('fadeIn').copyWith(visible: false)],
      ),
    );
    add('success', AnimationSequenceParams(effects: [ScaleParams.preset('pop'), ShakeParams.preset('nod')]));
    add(
      'attention',
      AnimationSequenceParams(effects: [FadeParams.preset('fadeIn'), ShakeParams.preset('mild')]),
    );
    add(
      'critical',
      AnimationSequenceParams(
        effects: [
          ShakeParams.preset('alert'),
          ScaleParams(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            begin: 1.0,
            end: 1.05,
            isScaled: true,
          ),
        ],
      ),
    );
    add(
      'entrance',
      AnimationSequenceParams(
        effects: [
          FadeParams.preset('fadeIn'),
          ScaleParams(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            begin: 0.9,
            end: 1.0,
            isScaled: true,
          ),
        ],
      ),
    );
    add(
      'exit',
      AnimationSequenceParams(
        effects: [
          ScaleParams(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInBack,
            begin: 1.0,
            end: 0.9,
            isScaled: true,
          ),
          FadeParams.preset('fadeOut'),
        ],
      ),
    );
  }

  static void register(String name, AnimationSequenceParams params) {
    instance._ensureInitialized();
    instance.add(name, params);
  }

  static AnimationSequenceParams? of(String name) {
    instance._ensureInitialized();
    return instance.get(name);
  }
}
