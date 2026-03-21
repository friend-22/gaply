import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/slide_params.dart';

class SlideWidget extends StatefulWidget {
  final Widget child;
  final SlideParams params;

  const SlideWidget({super.key, required this.child, this.params = const SlideParams()});

  @override
  State<SlideWidget> createState() => SlideWidgetState();
}

class SlideWidgetState extends State<SlideWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.params.duration,
      value: widget.params.visible ? 1.0 : 0.0,
    );

    _curve = CurvedAnimation(parent: _controller, curve: widget.params.curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
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
  void didUpdateWidget(covariant SlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _curve.curve = widget.params.curve;
    }

    if (widget.params.visible != oldWidget.params.visible) {
      widget.params.visible ? _controller.forward() : _controller.reverse();
    }
  }

  void toggle() => _controller.isCompleted ? hide() : show();
  void show() => _controller.forward();
  void hide() => _controller.reverse();

  double get _axisAlignment => widget.params.isReversed ? 1.0 : -1.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        if (_curve.value <= 0.001 && !widget.params.visible) {
          return const SizedBox.shrink();
        }

        Widget content = widget.params.useOpacity ? FadeTransition(opacity: _curve, child: child!) : child!;
        if (widget.params.fixedSize) return content;

        return ClipRect(
          child: SizeTransition(
            sizeFactor: _curve,
            axis: widget.params.axis,
            axisAlignment: _axisAlignment,
            child: content,
          ),
        );
      },
      child: widget.child,
    );
  }
}
