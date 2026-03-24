import 'dart:async';
import 'package:flutter/material.dart';
import 'gaply_style.dart';

mixin GaplyMotionTrigger<W extends StatefulWidget, MST extends GaplyAnimStyle, S extends State> on State<W> {
  final GlobalKey<S> triggerKey = GlobalKey<S>();
  Timer? _delayTimer;

  MST get style;
  Object? get trigger;

  void execute(MST style);

  @override
  void initState() {
    super.initState();

    if (style.isEnabled) {
      onNextRender(() => _delayAndExecute(style));
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void _delayAndExecute(MST style) {
    _delayTimer?.cancel();

    if (style.delay == Duration.zero) {
      execute(style);
    } else {
      onDelay(style.delay, () {
        if (!mounted) {
          print("🚨 딜레이 도중 위젯이 사라짐: ${style.delay}");
          return;
        }

        execute(style);
      });
    }
  }

  void checkAndExecute(MST oldStyle, Object? oldTrigger) {
    final isStyleChanged = style != oldStyle;
    final isTriggered = trigger != oldTrigger;

    if ((isStyleChanged || isTriggered) && style.isEnabled) {
      _delayAndExecute(style);
    }
  }

  void onNextRender(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  void onDelay(Duration duration, VoidCallback callback) {
    _delayTimer = Timer(duration, callback);
  }
}
