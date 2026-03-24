import 'package:flutter/material.dart';

import 'slide_style.dart';

class GaplySlide extends StatefulWidget {
  final Widget child;
  final SlideStyle style;

  const GaplySlide({super.key, required this.child, required this.style});

  @override
  State<GaplySlide> createState() => GaplySlideState();
}

class GaplySlideState extends State<GaplySlide> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.visible ? 1.0 : 0.0,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GaplySlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.visible != oldWidget.style.visible) {
      _execute(widget.style);
    }
  }

  void toggle() => _controller.isCompleted ? hide() : show();
  void show() => _controller.forward();
  void hide() => _controller.reverse();

  void _execute(SlideStyle style) {
    if (!mounted) return;

    if (style.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(SlideStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curve.curve = style.curve;

      _execute(style);
    });
  }

  double get _axisAlignment => widget.style.isReversed ? 1.0 : -1.0;

  @override
  Widget build(BuildContext context) {
    if (!widget.style.isEnabled) return widget.child;

    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        if (_controller.isDismissed && !widget.style.visible) {
          return const SizedBox.shrink();
        }

        Widget content = child!;

        if (widget.style.useOpacity) {
          content = FadeTransition(opacity: _curve, child: content);
        }

        if (widget.style.fixedSize) return content;

        return ClipRect(
          child: SizeTransition(
            sizeFactor: _curve,
            axis: widget.style.axis,
            axisAlignment: _axisAlignment,
            child: content,
          ),
        );
      },
      child: widget.child,
    );
  }
}
