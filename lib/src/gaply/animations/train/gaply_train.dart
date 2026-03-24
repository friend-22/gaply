import 'package:flutter/material.dart';

import 'train_style.dart';

class GaplyTrain<T> extends StatefulWidget {
  final T currentItem;
  final T? previousItem;
  final Widget Function(T item) itemBuilder;
  final TrainStyle style;

  const GaplyTrain({
    super.key,
    required this.currentItem,
    required this.previousItem,
    required this.itemBuilder,
    required this.style,
  });

  @override
  State<GaplyTrain<T>> createState() => GaplyTrainState<T>();
}

class GaplyTrainState<T> extends State<GaplyTrain<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  Axis get _axis => widget.style.axis;
  bool get _isForward => switch (widget.style.direction) {
    AxisDirection.left || AxisDirection.up => true,
    AxisDirection.right || AxisDirection.down => false,
  };
  bool get _isHorizontal => widget.style.isHorizontal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.style.duration);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.style.onComplete?.call();
      }
    });

    _curve = CurvedAnimation(parent: _controller, curve: widget.style.curve);
  }

  @override
  void didUpdateWidget(GaplyTrain<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curve.curve = widget.style.curve;
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

  void executeParams(TrainStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curve.curve = style.curve;

      _controller.forward(from: 0);
    });
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
      opacity: widget.style.useOpacity ? opacity.clamp(0.0, 1.0) : 1.0,
      child: SizedBox(width: _isHorizontal ? size : null, height: !_isHorizontal ? size : null, child: child),
    );
  }
}
