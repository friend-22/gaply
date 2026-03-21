import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/scale_params.dart';

class ScaleWidget extends StatefulWidget {
  final Widget child;
  final ScaleParams params;

  const ScaleWidget({super.key, required this.child, this.params = const ScaleParams()});

  @override
  State<ScaleWidget> createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<ScaleWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.params.duration,
      value: widget.params.isScaled ? 1.0 : 0.0,
    );

    _updateAnimation();
  }

  void _updateAnimation() {
    _scale = Tween<double>(
      begin: widget.params.begin,
      end: widget.params.end,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.params.curve));
  }

  @override
  void didUpdateWidget(ScaleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.begin != oldWidget.params.begin ||
        widget.params.end != oldWidget.params.end ||
        widget.params.curve != oldWidget.params.curve) {
      _updateAnimation();
    }

    if (widget.params.isScaled != oldWidget.params.isScaled) {
      if (widget.params.isScaled) {
        _controller.forward().then((_) => widget.params.onComplete?.call());
      } else {
        _controller.reverse().then((_) => widget.params.onComplete?.call());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, alignment: widget.params.alignment, child: widget.child);
  }
}
