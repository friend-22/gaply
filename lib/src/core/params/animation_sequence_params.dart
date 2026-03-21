import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gaply/src/core/base/gaply_base.dart';
import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/scale_params.dart';
import 'package:gaply/src/core/params/shake_params.dart';
import 'package:gaply/src/core/params/slide_params.dart';
import 'package:gaply/src/widget/fade_widget.dart';
import 'package:gaply/src/widget/scale_widget.dart';
import 'package:gaply/src/widget/shake_widget.dart';
import 'package:gaply/src/widget/slide_widget.dart';

import '../base/animation_params.dart';
import 'fade_params.dart';

@immutable
class AnimationSequenceParams extends ParamsBase<AnimationSequenceParams> {
  final List<AnimationParams> effects;

  const AnimationSequenceParams({this.effects = const []});

  factory AnimationSequenceParams.preset(String name) {
    return GaplyAnimationSequencePreset.of(name) ?? GaplyAnimationSequencePreset.of('none')!;
  }

  @override
  bool get isEnabled => effects.isNotEmpty;

  AnimationSequenceParams add(AnimationParams effect) {
    return AnimationSequenceParams(effects: [...effects, effect]);
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
      ShakeParams p => ShakeWidget(params: p, child: child),
      SlideParams p => SlideWidget(params: p, child: child),
      FadeParams p => FadeWidget(params: p, child: child),
      ScaleParams p => ScaleWidget(params: p, child: child),
      _ => child,
    };
  }
}

class GaplyAnimationSequencePreset with GaplyPreset<AnimationSequenceParams> {
  static final GaplyAnimationSequencePreset instance = GaplyAnimationSequencePreset._internal();

  GaplyAnimationSequencePreset._internal() {
    register('none', const AnimationSequenceParams());

    register(
      'error',
      AnimationSequenceParams(
        effects: [
          ShakeParams.preset('severe'),
          FadeParams(duration: const Duration(milliseconds: 100), visible: true),
        ],
      ),
    );

    register(
      'success',
      AnimationSequenceParams(effects: [ScaleParams.preset('pop'), ShakeParams.preset('nod')]),
    );

    register(
      'attention',
      AnimationSequenceParams(effects: [FadeParams.preset('fadeIn'), ShakeParams.preset('mild')]),
    );

    register(
      'critical',
      AnimationSequenceParams(
        effects: [
          ShakeParams.preset('alert'),
          ScaleParams(begin: 1.0, end: 1.05, duration: const Duration(milliseconds: 100)),
        ],
      ),
    );

    register(
      'entrance',
      AnimationSequenceParams(
        effects: [
          FadeParams.preset('fadeIn'),
          ScaleParams(begin: 0.9, end: 1.0, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  static void register(String name, AnimationSequenceParams params) => instance.add(name, params);

  static AnimationSequenceParams? of(String name) => instance.get(name);
}
