part of '../core/gaply_animation.dart';

class FadeWidget extends StatefulWidget {
  final Widget child;
  final FadeParams params;

  const FadeWidget({super.key, required this.child, required this.params});

  @override
  State<FadeWidget> createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.params.duration,
      value: widget.params.visible ? 0.0 : 1.0,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
        widget.params._internalComplete?.call();
      }
    });

    _opacity = CurvedAnimation(parent: _controller, curve: widget.params.curve);

    _execute(widget.params);
  }

  @override
  void didUpdateWidget(FadeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _opacity.curve = widget.params.curve;
    }

    if (widget.params.visible != oldWidget.params.visible) {
      _execute(widget.params);
    }
  }

  void _execute(FadeParams params) {
    if (params.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(FadeParams params) {
    if (!mounted) return;

    _controller.duration = params.duration;
    _opacity.curve = params.curve;

    _execute(params);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}

class FadeTrigger extends StatefulWidget {
  final Widget child;
  final FadeParams params;
  final Object? trigger;

  const FadeTrigger({super.key, required this.child, required this.params, this.trigger});

  @override
  State<FadeTrigger> createState() => FadeTriggerState();
}

class FadeTriggerState extends State<FadeTrigger>
    with GaplyTriggerMixin<FadeTrigger, FadeParams, _FadeWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  FadeParams get params => widget.params;

  @override
  void didUpdateWidget(FadeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.params, oldWidget.trigger);
  }

  @override
  void _execute(FadeParams params) {
    triggerKey.currentState?.executeParams(params);
  }

  @override
  Widget build(BuildContext context) {
    return FadeWidget(key: triggerKey, params: widget.params, child: widget.child);
  }
}
