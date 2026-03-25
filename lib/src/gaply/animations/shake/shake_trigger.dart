part of 'shake_style.dart';

class _GaplyShakeTrigger extends StatefulWidget {
  final Widget child;
  final ShakeStyle style;
  final Object? trigger;

  const _GaplyShakeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyShakeTrigger> createState() => _GaplyShakeTriggerState();
}

class _GaplyShakeTriggerState extends State<_GaplyShakeTrigger>
    with GaplyMotionTrigger<_GaplyShakeTrigger, ShakeStyle, GaplyShakeState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  ShakeStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyShakeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(ShakeStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyShake(key: triggerKey, style: widget.style, child: widget.child);
  }
}
