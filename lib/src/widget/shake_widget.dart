import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/shake_params.dart';
import 'package:gaply/src/utils/haptic_feedback.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final ShakeParams params;

  const ShakeWidget({super.key, required this.child, this.params = const ShakeParams()});

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;

  late double _activeDistance;
  late double _activeCount;
  late bool _isVertical;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.params.duration);
    _curvedAnimation = CurvedAnimation(parent: _controller, curve: widget.params.curve);

    _isVertical = widget.params.isVertical;
    _activeDistance = widget.params.distance;
    _activeCount = widget.params.count;

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.params.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.params.duration != oldWidget.params.duration) {
      _controller.duration = widget.params.duration;
    }

    if (widget.params.curve != oldWidget.params.curve) {
      _curvedAnimation = CurvedAnimation(parent: _controller, curve: widget.params.curve);
    }
  }

  void _execute({bool? vertical, double? distance, double? count, HapticType? haptic}) {
    if (widget.params.useHaptic && haptic != null) {
      haptic.feedback();
    }

    _isVertical = vertical ?? widget.params.isVertical;
    _activeDistance = distance ?? widget.params.distance;
    _activeCount = count ?? widget.params.count;

    _controller.forward(from: 0.0);
  }

  void shakeMild() => _execute(vertical: false, distance: 4.0, count: 2.0, haptic: HapticType.selection);

  /// Normal 흔들림
  void shakeNormal() => _execute(vertical: false, distance: 8.0, count: 4.0, haptic: HapticType.medium);

  /// Severe 흔들림
  void shakeSevere() => _execute(vertical: false, distance: 12.0, count: 7.0, haptic: HapticType.heavy);

  /// Alert 흔들림
  void shakeAlert() => _execute(vertical: false, distance: 6.0, count: 7.0, haptic: HapticType.heavy);

  /// Nod 효과
  void nod() => _execute(vertical: true, distance: 6.0, count: 2.0, haptic: HapticType.light);

  /// Celebrate 효과
  void celebrate() => _execute(vertical: true, distance: 10.0, count: 3.0, haptic: HapticType.medium);

  /// 커스텀 shake
  void shake({double? distance, double? count}) =>
      _execute(vertical: false, distance: distance, count: count);

  /// 커스텀 bounce (세로)
  void bounce({double? distance, double? count}) =>
      _execute(vertical: true, distance: distance, count: count);

  /// ShakeParams로부터 실행
  void executeParams(ShakeParams params) {
    _execute(vertical: params.isVertical, distance: params.distance, count: params.count);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dampingFactor = 1.0 - _curvedAnimation.value;
        final sineValue = sin(_controller.value * pi * 2 * _activeCount);
        final offset = sineValue * _activeDistance * dampingFactor;

        return Transform.translate(offset: _isVertical ? Offset(0, offset) : Offset(offset, 0), child: child);
      },
      child: widget.child,
    );

    return widget.params.useRepaintBoundary ? RepaintBoundary(child: result) : result;
  }
}
