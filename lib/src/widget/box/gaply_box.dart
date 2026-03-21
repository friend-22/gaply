import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/animation_sequence_params.dart';
import 'package:gaply/src/core/params/box_params.dart';

import 'mixin.dart';
import 'gaply_box_mixin.dart';

class GaplyBox extends StatelessWidget
    with AnimationSequenceParamsMixin, BoxParamsMixin, BoxStyleModifierMixin<GaplyBox> {
  @override
  final BoxParams params;
  final Widget child;

  const GaplyBox({super.key, this.params = const BoxParams(), required this.child});

  @override
  GaplyBox copyWith(BoxParams params) => GaplyBox(params: params, child: child);

  @override
  Widget build(BuildContext context) => applyAnimationSequence(params.animation, buildBox(context, child));
}
