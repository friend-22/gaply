import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/flip_params.dart';

class FlipWidget extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipParams flipParams;

  const FlipWidget({
    super.key,
    required this.front,
    required this.back,
    this.flipParams = const FlipParams(),
  });

  @override
  State<FlipWidget> createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.flipParams.duration,
      value: widget.flipParams.isFlipped ? 1.0 : 0.0,
    );

    _curve = CurvedAnimation(parent: _controller, curve: widget.flipParams.curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.flipParams.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.flipParams.duration != oldWidget.flipParams.duration) {
      _controller.duration = widget.flipParams.duration;
    }

    if (widget.flipParams.curve != oldWidget.flipParams.curve) {
      _curve.curve = widget.flipParams.curve;
    }

    if (widget.flipParams.isFlipped != oldWidget.flipParams.isFlipped) {
      widget.flipParams.isFlipped ? _controller.forward() : _controller.reverse();
    }
  }

  void flip() => widget.flipParams.isFlipped ? _controller.reverse() : _controller.forward();
  void toggle() => flip();
  void reset() => _controller.reset();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final angle = _curve.value * widget.flipParams.angleRange;
        final isBack = _curve.value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(widget.flipParams.axis == Axis.vertical ? angle : 0)
            ..rotateX(widget.flipParams.axis == Axis.horizontal ? angle : 0),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: widget.flipParams.axis == Axis.vertical
                      ? (Matrix4.identity()..rotateY(math.pi))
                      : (Matrix4.identity()..rotateX(math.pi)),
                  child: widget.back,
                )
              : widget.front,
        );
      },
    );
  }
}
