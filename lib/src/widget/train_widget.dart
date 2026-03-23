import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/train_params.dart';
import 'package:gaply/src/widget/trigger_mixin.dart';

class TrainWidget<T> extends StatefulWidget {
  final T currentItem;
  final T? previousItem;
  final Widget Function(T item) itemBuilder;
  final TrainParams params;

  const TrainWidget({
    super.key,
    required this.currentItem,
    required this.previousItem,
    required this.itemBuilder,
    required this.params,
  });

  @override
  State<TrainWidget<T>> createState() => _TrainWidgetState<T>();
}

class _TrainWidgetState<T> extends State<TrainWidget<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  Axis get _axis => widget.params.axis;
  bool get _isForward => switch (widget.params.direction) {
    AxisDirection.left || AxisDirection.up => true,
    AxisDirection.right || AxisDirection.down => false,
  };
  bool get _isHorizontal => widget.params.isHorizontal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.params.duration);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.params.curve);
  }

  @override
  void didUpdateWidget(TrainWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _curve.curve = widget.params.curve;
    }

    if (widget.previousItem != oldWidget.previousItem && widget.previousItem != null) {
      _controller.forward(from: 0);
    }

    if (widget.currentItem != oldWidget.currentItem) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void executeParams(TrainParams params) {
    _controller.duration = params.duration;
    _curve.curve = params.curve;

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.previousItem == null) {
      return widget.itemBuilder(widget.currentItem);
    }

    final prev = widget.itemBuilder(widget.previousItem as T);
    final curr = widget.itemBuilder(widget.currentItem);
    final first = _isForward ? prev : curr;
    final second = _isForward ? curr : prev;

    return AnimatedBuilder(
      animation: _curve,
      builder: (context, _) {
        return RepaintBoundary(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = _isHorizontal ? constraints.maxWidth : constraints.maxHeight;
              final travel = _isForward ? -size * _curve.value : -size + (size * _curve.value);
              final offset = _isHorizontal ? Offset(travel, 0) : Offset(0, travel);

              final double firstOpacity = 1.0 - _curve.value;
              final double secondOpacity = _curve.value;

              return ClipRect(
                child: Transform.translate(
                  offset: offset,
                  child: Flex(
                    direction: _axis,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTrainCar(first, firstOpacity, size),
                      _buildTrainCar(second, secondOpacity, size),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrainCar(Widget child, double opacity, double size) {
    return Opacity(
      opacity: widget.params.useOpacity ? opacity.clamp(0.0, 1.0) : 1.0,
      child: SizedBox(width: _isHorizontal ? size : null, height: !_isHorizontal ? size : null, child: child),
    );
  }
}

class TrainTrigger<T> extends StatefulWidget {
  final T currentItem;
  final T? previousItem;
  final Widget Function(T item) itemBuilder;
  final TrainParams params;
  final Object? trigger;

  const TrainTrigger({
    super.key,
    required this.currentItem,
    required this.previousItem,
    required this.itemBuilder,
    required this.params,
    this.trigger,
  });

  @override
  State<TrainTrigger> createState() => TrainTriggerState();
}

class TrainTriggerState<T> extends State<TrainTrigger<T>>
    with GaplyTriggerMixin<TrainTrigger<T>, TrainParams, _TrainWidgetState<T>> {
  @override
  Object? get trigger => widget.trigger;

  @override
  TrainParams get params => widget.params;

  @override
  void didUpdateWidget(TrainTrigger<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.params, oldWidget.trigger);
  }

  @override
  void execute(TrainParams params) {
    triggerKey.currentState?.executeParams(params);
  }

  @override
  Widget build(BuildContext context) {
    return TrainWidget<T>(
      key: triggerKey,
      params: widget.params,
      currentItem: widget.currentItem,
      previousItem: widget.previousItem,
      itemBuilder: widget.itemBuilder,
    );
  }
}
