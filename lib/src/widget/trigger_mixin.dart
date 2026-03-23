part of '../core/gaply_animation.dart';

mixin GaplyTriggerMixin<W extends StatefulWidget, P extends AnimationParams, S extends State> on State<W> {
  final GlobalKey<S> triggerKey = GlobalKey<S>();
  Timer? _delayTimer;

  P get params;
  Object? get trigger;

  void _execute(P params);

  @override
  void initState() {
    super.initState();

    if (params.isEnabled) {
      onNextRender(() => _delayAndExecute(params));
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void _delayAndExecute(P params) {
    _delayTimer?.cancel();

    if (params.delay == Duration.zero) {
      _execute(params);
    } else {
      onDelay(params.delay, () {
        if (!mounted) {
          print("🚨 딜레이 도중 위젯이 사라짐: ${params.delay}");
          return;
        }

        _execute(params);
      });
    }
  }

  void checkAndExecute(P oldParams, Object? oldTrigger) {
    final isParamsChanged = params != oldParams;
    final isTriggered = trigger != oldTrigger;

    if ((isParamsChanged || isTriggered) && params.isEnabled) {
      _delayAndExecute(params);
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
