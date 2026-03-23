part of '../core/gaply_animation.dart';

class SlideWidget extends StatefulWidget {
  final Widget child;
  final SlideParams params;

  const SlideWidget({super.key, required this.child, required this.params});

  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> with SingleTickerProviderStateMixin {
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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
        widget.params._internalComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.params.curve);
  }

  @override
  void dispose() {
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

  void executeParams(SlideParams params) {
    _controller.duration = params.duration;
    _curve.curve = params.curve;

    if (params.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  double get _axisAlignment => widget.params.isReversed ? 1.0 : -1.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        if (_controller.isDismissed && !widget.params.visible) {
          return const SizedBox.shrink();
        }

        Widget content = child!;

        if (widget.params.useOpacity) {
          content = FadeTransition(opacity: _curve, child: content);
        }

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

class SlideTrigger extends StatefulWidget {
  final Widget child;
  final SlideParams params;
  final Object? trigger;

  const SlideTrigger({super.key, required this.child, required this.params, this.trigger});

  @override
  State<SlideTrigger> createState() => SlideTriggerState();
}

class SlideTriggerState extends State<SlideTrigger>
    with GaplyTriggerMixin<SlideTrigger, SlideParams, _SlideWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  SlideParams get params => widget.params;

  @override
  void didUpdateWidget(SlideTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.params, oldWidget.trigger);
  }

  @override
  void _execute(SlideParams params) {
    triggerKey.currentState?.executeParams(params);
  }

  @override
  Widget build(BuildContext context) {
    return SlideWidget(key: triggerKey, params: widget.params, child: widget.child);
  }
}
