part of 'gaply_shake.dart';

class _GaplyShakeTrigger extends StatefulWidget {
  final Widget child;
  final GaplyShake style;
  final Object? trigger;

  const _GaplyShakeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyShakeTrigger> createState() => _GaplyShakeTriggerState();
}

class _GaplyShakeTriggerState extends State<_GaplyShakeTrigger>
    with GaplyMotionTrigger<_GaplyShakeTrigger, GaplyShake, GaplyShakeWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyShake get style => widget.style;

  @override
  void didUpdateWidget(_GaplyShakeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyShake style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyShakeWidget(key: triggerKey, style: widget.style, child: widget.child);
  }
}
