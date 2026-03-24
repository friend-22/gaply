import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'rotate_style.dart';

class GaplyRotate extends StatefulWidget {
  final Widget child;
  final RotateStyle style;

  const GaplyRotate({super.key, required this.child, required this.style});

  @override
  State<GaplyRotate> createState() => GaplyRotateState();
}

class GaplyRotateState extends State<GaplyRotate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late final Animation<double> _turns;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isRotated ? 1.0 : 0.0,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.style.onComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.style.curve);

    _updateAnimation();

    _execute(widget.style);
  }

  @override
  void didUpdateWidget(GaplyRotate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.begin != oldWidget.style.begin ||
        widget.style.end != oldWidget.style.end ||
        widget.style.useRadians != oldWidget.style.useRadians) {
      _updateAnimation();
    }

    if (widget.style.isRotated != oldWidget.style.isRotated) {
      _execute(widget.style);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    double beginTurns;
    double endTurns;

    if (widget.style.useRadians) {
      beginTurns = widget.style.begin / (2 * math.pi);
      endTurns = widget.style.end / (2 * math.pi);
    } else {
      beginTurns = widget.style.begin / 360.0;
      endTurns = widget.style.end / 360.0;
    }

    _turns = Tween<double>(begin: beginTurns, end: endTurns).animate(_curve);
  }

  void _execute(RotateStyle style) {
    if (!mounted) return;

    if (style.isRotated) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(RotateStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curve.curve = style.curve;

      _execute(style);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.style.isEnabled) return widget.child;

    return RotationTransition(turns: _turns, alignment: widget.style.alignment, child: widget.child);
  }
}
