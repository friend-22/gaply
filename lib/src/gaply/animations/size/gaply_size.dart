import 'package:flutter/material.dart';

import 'size_style.dart';

class GaplySize extends StatefulWidget {
  final Widget child;
  final SizeStyle style;

  const GaplySize({super.key, required this.child, required this.style});

  @override
  State<GaplySize> createState() => GaplySizeState();
}

class GaplySizeState extends State<GaplySize> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isExpanded ? 1.0 : 0.0,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GaplySize oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.minFactor != oldWidget.style.minFactor) {
      _updateAnimation();
    }

    if (widget.style.isExpanded != oldWidget.style.isExpanded) {
      _execute(widget.style);
    }
  }

  void toggle() => _controller.isCompleted ? hide() : show();
  void show() => _controller.forward();
  void hide() => _controller.reverse();

  void _updateAnimation() {
    _sizeAnimation = Tween<double>(begin: widget.style.minFactor, end: 1.0).animate(_curve);
  }

  void _execute(SizeStyle style) {
    if (!mounted) return;

    if (style.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(SizeStyle style) {
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

    return widget.style.profiler.trace(() {
      return AnimatedBuilder(
        animation: _sizeAnimation,
        builder: (context, child) {
          if (_controller.isDismissed && widget.style.minFactor == 0) {
            return const SizedBox.shrink();
          }

          return ClipRect(
            child: SizeTransition(
              sizeFactor: _sizeAnimation,
              axis: widget.style.axis,
              axisAlignment: widget.style.axisAlignment,
              child: child,
            ),
          );
        },
        child: widget.child,
      );
    }, tag: 'build');
  }
}
