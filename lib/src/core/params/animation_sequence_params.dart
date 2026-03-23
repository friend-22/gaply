import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/scale_params.dart';
import 'package:gaply/src/core/params/shake_params.dart';
import 'package:gaply/src/core/params/slide_params.dart';
import 'package:gaply/src/core/params/flip_params.dart';

import '../base/animation_params.dart';
import 'fade_params.dart';

@immutable
class AnimationSequenceParams extends ParamsBase<AnimationSequenceParams> {
  final List<AnimationParams> effects;
  final List<AnimationSequenceParams> children;

  const AnimationSequenceParams({required this.effects, this.children = const []});

  const AnimationSequenceParams.none() : this(effects: const []);

  factory AnimationSequenceParams.preset(String name) {
    final params = GaplyAnimationSequencePreset.of(name);
    if (params == null) {
      throw ArgumentError('Unknown animation sequence preset: "$name"');
    }
    return params;
  }

  @override
  bool get isEnabled => effects.isNotEmpty;

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

  @override
  AnimationSequenceParams copyWith({List<AnimationParams>? effects}) {
    return AnimationSequenceParams(effects: effects ?? this.effects);
  }

  @override
  List<Object?> get props => [effects];
}

/// AnimationSequenceParams를 Widget에 적용하는 확장 메서드
mixin AnimationSequenceParamsMixin {
  Widget applyAnimationSequence(AnimationSequenceParams params, Widget child) {
    if (params.effects.isEmpty) return child;

    Widget result = child;

    for (final effect in params.effects) {
      result = _wrapWithEffect(result, effect);
    }

    return result;
  }

  Widget _wrapWithEffect(Widget child, AnimationParams effect) {
    return switch (effect) {
      FadeParams p => p.buildWidget(child: child),
      ShakeParams p => p.buildWidget(child: child),
      SlideParams p => p.buildWidget(child: child),
      ScaleParams p => p.buildWidget(child: child),
      FlipParams p => p.buildWidget(front: child, back: child), // 추가
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
