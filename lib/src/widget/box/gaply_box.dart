import 'package:flutter/material.dart';
import '../../../gaply.dart';


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
