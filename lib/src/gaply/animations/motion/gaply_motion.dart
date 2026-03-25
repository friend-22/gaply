import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';

import 'motion_presets.dart';

@immutable
class GaplyMotion extends GaplyStyle<GaplyMotion> with GaplyMotionMixin {
  final List<GaplyAnimStyle> animations;
  final List<GaplyMotion> children;
  final VoidCallback? onComplete;

  const GaplyMotion({required this.animations, this.children = const [], this.onComplete});

  const GaplyMotion.none() : this(animations: const []);

  static void register(String name, GaplyMotion style) => GaplyMotionPreset.register(name, style);

  factory GaplyMotion.preset(String name) {
    final style = GaplyMotionPreset.of(name);
    if (style == null) {
      throw ArgumentError('Unknown animations sequence preset: "$name"');
    }
    return style;
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

    final int maxLength = math.max(animations.length, other.animations.length);
    final List<GaplyAnimStyle> lerpAnimations = [];

    for (int i = 0; i < maxLength; i++) {
      if (i < animations.length && i < other.animations.length) {
        lerpAnimations.add(animations[i].lerp(other.animations[i], t));
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
      animations: lerpAnimations,
      children: lerpChildren,
      onComplete: t < 0.5 ? onComplete : other.onComplete,
    );
  }

  @override
  GaplyMotion copyWith({
    List<GaplyAnimStyle>? animations,
    List<GaplyMotion>? children,
    VoidCallback? onComplete,
  }) {
    return GaplyMotion(
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

  Widget buildWidget({required Widget child, Object? trigger}) {
    return applyMotion(this, child, trigger: trigger);
  }
}

mixin GaplyMotionMixin {
  Widget applyMotion(GaplyMotion motion, Widget child, {Object? trigger}) {
    if (!motion.hasEffect) return child;

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
      var anim = animations[i];

      if (i == animations.length - 1 && finalCallback != null) {
        final VoidCallback? existingOnComplete = anim.onComplete;

        if (anim is GaplyAnimMixin) {
          anim = (anim as GaplyAnimMixin).copyWith(
            onComplete: () {
              existingOnComplete?.call();
              finalCallback.call();
            },
          );
        }
      }

      result = anim.buildWidget(child: result, trigger: trigger);
    }
    return result;
  }
}
