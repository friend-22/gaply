import 'package:flutter/material.dart';

import 'skew_style.dart';

class GaplySkew extends StatefulWidget {
  final Widget child;
  final SkewStyle style;

  const GaplySkew({super.key, required this.child, required this.style});

  @override
  State<GaplySkew> createState() => GaplySkewState();
}

class GaplySkewState extends State<GaplySkew> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late Animation<Offset> _skewAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isSkewed ? 1.0 : 0.0,
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
  void didUpdateWidget(covariant GaplySkew oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
    }

    if (widget.style.skew != oldWidget.style.skew) {
      _updateAnimation();
    }

    if (widget.style.isSkewed != oldWidget.style.isSkewed) {
      _execute(widget.style);
    }
  }

  void _updateAnimation() {
    _skewAnimation = Tween<Offset>(begin: Offset.zero, end: widget.style.skew).animate(_curve);
  }

  void _execute(SkewStyle style) {
    if (!mounted) return;

    if (style.isSkewed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(SkewStyle style) {
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

    return AnimatedBuilder(
      animation: _skewAnimation,
      builder: (context, child) {
        final skewValue = _skewAnimation.value;
        return Transform(
          transform: Matrix4.skew(skewValue.dx, skewValue.dy),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
