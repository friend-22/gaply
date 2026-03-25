import 'package:flutter/material.dart';

import 'scale_style.dart';

class GaplyScale extends StatefulWidget {
  final Widget child;
  final ScaleStyle style;

  const GaplyScale({super.key, required this.child, required this.style});

  @override
  State<GaplyScale> createState() => GaplyScaleState();
}

class GaplyScaleState extends State<GaplyScale> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isScaled ? 1.0 : 0.0,
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
  void didUpdateWidget(GaplyScale oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.begin != oldWidget.style.begin || widget.style.end != oldWidget.style.end) {
      _updateAnimation();
    }

    if (widget.style.isScaled != oldWidget.style.isScaled) {
      _execute(widget.style);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    _scale = Tween<double>(begin: widget.style.begin, end: widget.style.end).animate(_curve);
  }

  void _execute(ScaleStyle style) {
    if (!mounted) return;

    if (style.isScaled) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(ScaleStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curve.curve = style.curve;

      _execute(style);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.style.hasEffect) return widget.child;

    return ScaleTransition(scale: _scale, alignment: widget.style.alignment, child: widget.child);
  }
}
