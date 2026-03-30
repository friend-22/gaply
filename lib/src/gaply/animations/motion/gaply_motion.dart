import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/gaply/core/gaply_defines.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'package:gaply/src/gaply/animations/animations.dart';

part 'gaply_motion.preset.g.dart';

abstract class GaplyAnim {
  GaplyAnim lerp(GaplyAnim? other, double t);
  Widget buildWidget({required Widget child, Object? trigger});
}

@immutable
@GaplyPresetGen(initializer: '_initPresets')
class GaplyMotion extends GaplyStyle<GaplyMotion>
    with GaplyMotionMixin, _GaplyMotionMixin, GaplyMotionModifier<GaplyMotion> {
  final List<GaplyAnimStyle> animations;
  final List<GaplyMotion> children;
  final VoidCallback? onComplete;

  const GaplyMotion({super.profiler, required this.animations, this.children = const [], this.onComplete});

  const GaplyMotion.none() : this(animations: const []);

  static GaplyMotionPreset preset = GaplyMotionPreset._i;

  factory GaplyMotion.of(Object key, {GaplyProfiler? profiler, VoidCallback? onComplete}) {
    final style = preset.get(key);
    if (style == null) {
      throw ArgumentError(preset.error(key));
    }
    return style.copyWith(profiler: profiler, onComplete: onComplete);
  }

  GaplyMotion addAnimation(GaplyAnimStyle style) {
    return copyWith(animations: [...animations, style]);
  }

  GaplyMotion addAnimations(List<GaplyAnimStyle> newStyles) {
    return copyWith(animations: [...animations, ...newStyles]);
  }

  @override
  GaplyMotion lerp(GaplyMotion? other, double t) {
    if (other == null) return this;

    return profiler.trace(() {
      final int maxLength = math.max(animations.length, other.animations.length);
      final List<GaplyAnimStyle> lerpAnimations = [];

      for (int i = 0; i < maxLength; i++) {
        if (i < animations.length && i < other.animations.length) {
          final anim = animations[i];
          final otherAnim = other.animations[i];
          lerpAnimations.add((anim as dynamic).lerp(otherAnim, t) as GaplyAnimStyle);
        } else if (i < other.animations.length) {
          if (t >= 0.5) lerpAnimations.add(other.animations[i]);
        } else {
          if (t < 0.5) lerpAnimations.add(animations[i]);
        }
      }

      final int maxChildren = math.max(children.length, other.children.length);
      final List<GaplyMotion> lerpChildren = [];

      for (int i = 0; i < maxChildren; i++) {
        if (i < children.length && i < other.children.length) {
          lerpChildren.add(children[i].lerp(other.children[i], t));
        } else if (i < other.children.length) {
          if (t >= 0.5) lerpChildren.add(other.children[i]);
        } else {
          if (t < 0.5) lerpChildren.add(children[i]);
        }
      }

      return GaplyMotion(
        profiler: other.profiler,
        animations: lerpAnimations,
        children: lerpChildren,
        onComplete: t < 0.5 ? onComplete : other.onComplete,
      );
    }, tag: 'lerp');
  }

  @override
  GaplyMotion copyWith({
    GaplyProfiler? profiler,
    List<GaplyAnimStyle>? animations,
    List<GaplyMotion>? children,
    VoidCallback? onComplete,
  }) {
    return GaplyMotion(
      profiler: profiler ?? this.profiler,
      animations: animations ?? this.animations,
      children: children ?? this.children,
      onComplete: onComplete ?? this.onComplete,
    );
  }

  @override
  List<Object?> get props => [animations, children, onComplete];

  @override
  bool get hasEffect {
    final hasActiveAnimation = animations.any((anim) => anim.hasEffect);
    final hasActiveChildren = children.any((child) => child.hasEffect);
    return hasActiveAnimation || hasActiveChildren;
  }

  Duration get maxDuration {
    if (animations.isEmpty) return Duration.zero;

    int maxMs = 0;
    for (var anim in animations) {
      final current = anim.duration.inMilliseconds + anim.delay.inMilliseconds;
      if (current > maxMs) maxMs = current;
    }

    return Duration(milliseconds: maxMs);
  }
}

mixin _GaplyMotionMixin on GaplyMotionMixin {
  GaplyMotion get _self => this as GaplyMotion;
  GaplyMotion get gaplyMotion => _self;

  GaplyMotion copyWithMotion(GaplyMotion motion) {
    return _self.copyWith(
      profiler: motion.profiler,
      animations: motion.animations,
      children: motion.children,
      onComplete: motion.onComplete,
    );
  }

  Widget buildWidget({required Widget child, Object? trigger}) {
    return applyMotion(_self, child, trigger: trigger);
  }
}

mixin GaplyMotionMixin {
  Widget applyMotion(GaplyMotion motion, Widget child, {Object? trigger}) {
    if (!motion.hasEffect) return child;

    return motion.profiler.trace(() {
      Widget result = child;

      if (motion.children.isNotEmpty) {
        result = _buildChildrenChain(motion, result, trigger);
      }

      return _buildAnimChain(
        animations: motion.animations,
        child: result,
        trigger: trigger,
        finalCallback: motion.children.isEmpty ? motion.onComplete : null,
      );
    }, tag: 'applyMotion');
  }

  Widget _buildChildrenChain(GaplyMotion motion, Widget child, Object? trigger) {
    Widget result = child;
    final parentDuration = motion.maxDuration;

    for (int i = motion.children.length - 1; i >= 0; i--) {
      var childSeq = motion.children[i];

      final isLastChild = (i == motion.children.length - 1);
      if (isLastChild) {
        final VoidCallback? childOriginalComplete = childSeq.onComplete;

        childSeq = childSeq.copyWith(
          onComplete: () {
            childOriginalComplete?.call();
            motion.onComplete?.call();
          },
        );
      }

      final delayedStyles = childSeq.animations.map((e) => e.withDelay(parentDuration)).toList();
      result = applyMotion(childSeq.copyWith(animations: delayedStyles), result, trigger: trigger);
    }
    return result;
  }

  Widget _buildAnimChain({
    required List<GaplyAnimStyle> animations,
    required Widget child,
    required Object? trigger,
    VoidCallback? finalCallback,
  }) {
    Widget result = child;

    for (int i = 0; i < animations.length; i++) {
      GaplyAnimStyle<dynamic> anim = animations[i];

      if (i == animations.length - 1 && finalCallback != null) {
        final VoidCallback? existingOnComplete = anim.onComplete;

        anim = anim.copyWith(
          onComplete: () {
            existingOnComplete?.call();
            finalCallback.call();
          },
        );
      }

      result = anim.buildWidget(child: result, trigger: trigger);
    }
    return result;
  }
}

void _initPresets(GaplyMotionPreset preset) {
  preset.add(
    'entrance',
    const GaplyMotion(
      animations: [
        GaplyFade(isVisible: true, duration: Duration(milliseconds: 500)),
        GaplyTranslate(
          begin: Offset(0, 10),
          end: Offset.zero,
          isMoved: true,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ),
      ],
    ),
  );
  preset.add(
    'pop',
    const GaplyMotion(
      animations: [
        GaplyScale(
          begin: 0.8,
          end: 1.0,
          isScaled: true,
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
        ),
        GaplyRotate(
          begin: -5,
          end: 0,
          isRotated: true,
          duration: Duration(milliseconds: 600),
          curve: Curves.elasticOut,
        ),
      ],
    ),
  );

  preset.add(
    'attention',
    const GaplyMotion(
      animations: [
        GaplyScale(begin: 1.0, end: 1.05, isScaled: true, duration: Duration(milliseconds: 200)),
        GaplyShake(duration: Duration(milliseconds: 500), distance: 4.0, count: 3.0, curve: Curves.linear),
      ],
    ),
  );

  preset.add(
    'cardHover',
    const GaplyMotion(
      animations: [
        GaplyTranslate(
          begin: Offset.zero,
          end: Offset(0, -6),
          isMoved: true,
          duration: Duration(milliseconds: 300),
        ),
        GaplyScale(begin: 1.0, end: 1.02, isScaled: true, duration: Duration(milliseconds: 300)),
      ],
    ),
  );

  preset.add(
    'introAndShake',
    GaplyMotion(
      animations: [GaplyFade(isVisible: true, duration: const Duration(milliseconds: 400))],
      children: [
        const GaplyMotion(
          animations: [GaplyShake(distance: 2.0, count: 2.0, duration: Duration(milliseconds: 300))],
        ),
      ],
    ),
  );
}
