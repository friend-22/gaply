import 'package:flutter/material.dart';
import 'fade_style.dart';

/// A widget that applies a fade animation to its child based on [GaplyFadeStyle].
///
/// It uses [FadeTransition] internally for high-performance opacity changes.
class GaplyFade extends StatefulWidget {
  /// The widget to apply the fade effect to.
  final Widget child;

  /// The configuration for the fade animation.
  final GaplyFadeStyle style;

  const GaplyFade({super.key, required this.child, required this.style});

  @override
  State<GaplyFade> createState() => GaplyFadeState();
}

/// State for [GaplyFade] that manages the [AnimationController].
class GaplyFadeState extends State<GaplyFade> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.duration,
      value: widget.style.isVisible ? 0.0 : 1.0,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.style.onComplete?.call();
      }
    });

    _opacity = CurvedAnimation(parent: _controller, curve: widget.style.curve);

    _execute(widget.style);
  }

  @override
  void didUpdateWidget(GaplyFade oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.style.duration != oldWidget.style.duration) {
      _controller.duration = widget.style.duration;
    }

    if (widget.style.curve != oldWidget.style.curve) {
      _opacity.curve = widget.style.curve;
    }

    if (widget.style.isVisible != oldWidget.style.isVisible) {
      _execute(widget.style);
    }
  }

  /// Reverses the current animation direction.
  void reverse() => widget.style.isVisible ? _controller.reverse() : _controller.forward();

  /// Resets the animation to its beginning.
  void reset() => _controller.reset();

  /// Internal execution logic to start the animation.
  void _execute(GaplyFadeStyle style) {
    if (!mounted) return;

    if (style.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void executeParams(GaplyFadeStyle style) {
    Future.delayed(style.delay, () {
      if (!mounted) return;

      _controller.duration = style.duration;
      _opacity.curve = style.curve;

      _execute(style);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.style.hasEffect) return widget.child;

    return widget.style.profiler.trace(() {
      return FadeTransition(opacity: _opacity, child: widget.child);
    }, tag: 'build');
  }
}
