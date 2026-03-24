import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'flip_style.dart';

/// A widget that performs a 3D flip transition between a front and back widget.
///
/// ### Example with GlobalKey:
///
/// ```dart
/// final flipKey = GlobalKey<GaplyFlipState>();
///
/// GaplyFlip(
///   key: flipKey,
///   front: MyFrontWidget(),
///   back: MyBackWidget(),
///   style: FlipStyle(axis: Axis.vertical, isFlipped: false),
/// );
class GaplyFlip extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipStyle style;

  const GaplyFlip({super.key, required this.front, required this.back, required this.style});

  @override
  State<GaplyFlip> createState() => GaplyFlipState();
}

class GaplyFlipState extends State<GaplyFlip> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isFlipped ? 1.0 : 0.0,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.style.onComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.style.curve);

    _execute(widget.style);
  }

  @override
  void didUpdateWidget(GaplyFlip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.isFlipped != oldWidget.style.isFlipped) {
      _execute(widget.style);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flip() => widget.style.isFlipped ? _controller.reverse() : _controller.forward();
  void toggle() => flip();
  void reset() => _controller.reset();

  void _execute(FlipStyle style) {
    if (!mounted) return;

    if (style.isFlipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(FlipStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curve.curve = style.curve;

      _execute(style);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.style.isEnabled) return widget.front;

    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final angle = _curve.value * widget.style.angleRange;
        final isBack = _curve.value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(widget.style.axis == Axis.vertical ? angle : 0)
            ..rotateX(widget.style.axis == Axis.horizontal ? angle : 0),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: widget.style.axis == Axis.vertical
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
