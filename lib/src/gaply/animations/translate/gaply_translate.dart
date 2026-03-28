import 'package:flutter/material.dart';

import 'translate_style.dart';

class GaplyTranslate extends StatefulWidget {
  final Widget child;
  final TranslateStyle style;

  const GaplyTranslate({super.key, required this.child, required this.style});

  @override
  State<GaplyTranslate> createState() => GaplyTranslateState();
}

class GaplyTranslateState extends State<GaplyTranslate> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isMoved ? 1.0 : 0.0,
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
  void didUpdateWidget(covariant GaplyTranslate oldWidget) {
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

    if (widget.style.isMoved != oldWidget.style.isMoved) {
      _execute(widget.style);
    }
  }

  void _updateAnimation() {
    _offsetAnimation = Tween<Offset>(begin: widget.style.begin, end: widget.style.end).animate(_curve);
  }

  void _execute(TranslateStyle style) {
    if (!mounted) return;

    if (style.isMoved) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(TranslateStyle style) {
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
        animation: _offsetAnimation,
        builder: (context, child) {
          return Transform.translate(offset: _offsetAnimation.value, child: child);
        },
        child: widget.child,
      );
    }, tag: 'build');
  }
}
