import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/scale_params.dart';
import 'package:gaply/src/widget/trigger_mixin.dart';

class ScaleWidget extends StatefulWidget {
  final Widget child;
  final ScaleParams params;

  const ScaleWidget({super.key, required this.child, required this.params});

  @override
  State<ScaleWidget> createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<ScaleWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.params.duration,
      value: widget.params.isScaled ? 1.0 : 0.0,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.params.curve);
    _updateAnimation();
  }

  void _updateAnimation() {
    _scale = Tween<double>(begin: widget.params.begin, end: widget.params.end).animate(_curve);
  }

  @override
  void didUpdateWidget(ScaleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _curve.curve = widget.params.curve;
    }

    if (widget.params.begin != oldWidget.params.begin || widget.params.end != oldWidget.params.end) {
      _updateAnimation();
    }

    if (widget.params.isScaled != oldWidget.params.isScaled) {
      widget.params.isScaled ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void executeParams(ScaleParams params) {
    _controller.duration = params.duration;
    _curve.curve = params.curve;

    if (params.isScaled) {
      _controller.forward(from: _controller.value == 1.0 ? 0.0 : _controller.value);
    } else {
      _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, alignment: widget.params.alignment, child: widget.child);
  }
}

class ScaleTrigger extends StatefulWidget {
  final Widget child;
  final ScaleParams params;
  final Object? trigger;

  const ScaleTrigger({super.key, required this.child, required this.params, this.trigger});

  @override
  State<ScaleTrigger> createState() => ScaleTriggerState();
}

class ScaleTriggerState extends State<ScaleTrigger>
    with GaplyTriggerMixin<ScaleTrigger, ScaleParams, _ScaleWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  ScaleParams get params => widget.params;

  @override
  void didUpdateWidget(ScaleTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.params, oldWidget.trigger);
  }

  @override
  void execute(ScaleParams params) {
    triggerKey.currentState?.executeParams(params);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleWidget(key: triggerKey, params: widget.params, child: widget.child);
  }
}
