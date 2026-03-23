part of '../core/gaply_animation.dart';

class FlipWidget extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipParams params;

  const FlipWidget({super.key, required this.front, required this.back, required this.params});

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
      duration: widget.params.duration,
      value: widget.params.isFlipped ? 1.0 : 0.0,
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
  void didUpdateWidget(FlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _curve.curve = widget.params.curve;
    }

    if (widget.params.isFlipped != oldWidget.params.isFlipped) {
      widget.params.isFlipped ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flip() => widget.params.isFlipped ? _controller.reverse() : _controller.forward();
  void toggle() => flip();
  void reset() => _controller.reset();

  void executeParams(FlipParams params) {
    if (!mounted) return;

    _controller.duration = params.duration;
    _curve.curve = params.curve;

    if (params.isFlipped) {
      _controller.reverse(from: _controller.value == 1.0 ? 0.0 : _controller.value);
    } else {
      _controller.forward(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final angle = _curve.value * widget.params.angleRange;
        final isBack = _curve.value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(widget.params.axis == Axis.vertical ? angle : 0)
            ..rotateX(widget.params.axis == Axis.horizontal ? angle : 0),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: widget.params.axis == Axis.vertical
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

class FlipTrigger extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipParams params;
  final Object? trigger;

  const FlipTrigger({super.key, required this.front, required this.back, required this.params, this.trigger});

  @override
  State<FlipTrigger> createState() => FlipTriggerState();
}

class FlipTriggerState extends State<FlipTrigger>
    with GaplyTriggerMixin<FlipTrigger, FlipParams, _FlipWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  FlipParams get params => widget.params;

  @override
  void didUpdateWidget(FlipTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.params, oldWidget.trigger);
  }

  @override
  void _execute(FlipParams params) {
    triggerKey.currentState?.executeParams(params);
  }

  @override
  Widget build(BuildContext context) {
    return FlipWidget(key: triggerKey, params: widget.params, front: widget.front, back: widget.back);
  }
}
