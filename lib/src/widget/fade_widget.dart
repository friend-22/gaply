import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/fade_params.dart';

class FadeWidget extends StatefulWidget {
  final Widget child;
  final FadeParams params;

  const FadeWidget({super.key, required this.child, this.params = const FadeParams()});

  @override
  State<FadeWidget> createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.params.duration,
      value: widget.params.visible ? 1.0 : 0.0,
    );

    _setCurve();
  }

  void _setCurve() {
    _opacity = CurvedAnimation(parent: _controller, curve: widget.params.curve);
  }

  @override
  void didUpdateWidget(FadeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _setCurve();
    }

    if (widget.params.visible != oldWidget.params.visible) {
      final status = widget.params.visible ? _controller.forward() : _controller.reverse();
      status.then((_) => widget.params.onComplete?.call());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}
