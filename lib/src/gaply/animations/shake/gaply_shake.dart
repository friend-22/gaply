import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gaply/src/utils/haptic_feedback.dart';

import 'shake_style.dart';

class GaplyShake extends StatefulWidget {
  final Widget child;
  final ShakeStyle style;

  const GaplyShake({super.key, required this.child, required this.style});

  @override
  State<GaplyShake> createState() => GaplyShakeState();
}

class GaplyShakeState extends State<GaplyShake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;

  late double _activeDistance;
  late double _activeCount;
  late bool _isVertical;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.style.duration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.style.onComplete?.call();
      }
    });

    _curved = CurvedAnimation(parent: _controller, curve: widget.style.curve);

    _isVertical = widget.style.isVertical;
    _activeDistance = widget.style.distance;
    _activeCount = widget.style.count;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GaplyShake oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _curved.curve = widget.style.curve;
    }
  }

  void _execute({bool? vertical, double? distance, double? count, HapticType? haptic}) {
    if (widget.style.useHaptic && haptic != null) {
      haptic.feedback();
    }

    _isVertical = vertical ?? widget.style.isVertical;
    _activeDistance = distance ?? widget.style.distance;
    _activeCount = count ?? widget.style.count;

    if (_controller.isAnimating) {
      _controller.stop();
    }

    _controller.forward(from: 0.0);
  }

  void shakeMild() => _execute(vertical: false, distance: 4.0, count: 2.0, haptic: HapticType.selection);
  void shakeNormal() => _execute(vertical: false, distance: 8.0, count: 4.0, haptic: HapticType.medium);
  void shakeSevere() => _execute(vertical: false, distance: 12.0, count: 7.0, haptic: HapticType.heavy);
  void shakeAlert() => _execute(vertical: false, distance: 6.0, count: 7.0, haptic: HapticType.heavy);
  void nod() => _execute(vertical: true, distance: 6.0, count: 2.0, haptic: HapticType.light);
  void celebrate() => _execute(vertical: true, distance: 10.0, count: 3.0, haptic: HapticType.medium);
  void shake({double? distance, double? count}) =>
      _execute(vertical: false, distance: distance, count: count);
  void bounce({double? distance, double? count}) =>
      _execute(vertical: true, distance: distance, count: count);

  void executeParams(ShakeStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _curved.curve = style.curve;

      _execute(vertical: style.isVertical, distance: style.distance, count: style.count);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dampingFactor = 1.0 - _curved.value;
        final sineValue = math.sin(_controller.value * math.pi * 2 * _activeCount);
        final offset = sineValue * _activeDistance * dampingFactor;
        return Transform.translate(offset: _isVertical ? Offset(0, offset) : Offset(offset, 0), child: child);
      },
      child: widget.child,
    );

    return widget.style.useRepaintBoundary ? RepaintBoundary(child: result) : result;
  }
}
