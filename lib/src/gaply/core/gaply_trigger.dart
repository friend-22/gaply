import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gaply/src/utils/gaply_perf.dart';
import 'gaply_style.dart';

/// Mixin that handles animation triggering based on style or trigger changes.
///
/// This mixin provides automatic animation execution when:
/// - The widget initializes
/// - The [trigger] value changes
/// - The [style] changes
///
/// Animation delays are automatically applied and safe disposal is guaranteed.

mixin GaplyMotionTrigger<W extends StatefulWidget, MST extends GaplyAnimStyle<MST>, S extends State>
    on State<W> {
  /// Global key to access the animation state
  final GlobalKey<S> triggerKey = GlobalKey<S>();

  /// Timer for delaying animation execution
  Timer? _delayTimer;

  /// Returns the animation style that controls timing and easing
  MST get style;

  /// Returns a trigger value that, when changed, restarts the animation
  Object? get trigger;

  /// Executes the animation with the given style
  void execute(MST style);

  @override
  void initState() {
    super.initState();

    if (style.hasEffect) {
      onNextRender(() => _delayAndExecute(style));
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  /// Delays animation execution based on style.delay, then executes safely
  void _delayAndExecute(MST style) {
    _delayTimer?.cancel();

    if (style.delay == Duration.zero) {
      execute(style);
    } else {
      onDelay(style.delay, () {
        if (!mounted) {
          // Widget was disposed during delay - safe to ignore
          GaplyLogger.i("🚨 딜레이 도중 위젯이 사라짐: ${style.delay}");
          return;
        }

        _safeExecute(style);
      });
    }
  }

  /// Safely executes animation with error handling
  void _safeExecute(MST style) {
    try {
      execute(style);
    } catch (e, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
          library: 'gaply',
          context: ErrorDescription('Failed to execute animation style: $style'),
        ),
      );
    }
  }

  /// Checks if style or trigger changed and executes animation if needed
  void checkAndExecute(MST oldStyle, Object? oldTrigger) {
    final isStyleChanged = style != oldStyle;
    final isTriggered = trigger != oldTrigger;

    if ((isStyleChanged || isTriggered) && style.hasEffect) {
      _delayAndExecute(style);
    }
  }

  /// Schedules callback after the current frame completes
  void onNextRender(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  /// Schedules callback after specified duration
  void onDelay(Duration duration, VoidCallback callback) {
    _delayTimer = Timer(duration, callback);
  }
}
