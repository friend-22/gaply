part of 'gaply_fade.dart';

class _GaplyFadeTrigger extends StatefulWidget {
  final Widget child;
  final GaplyFade style;
  final Object? trigger;

  const _GaplyFadeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyFadeTrigger> createState() => _GaplyFadeTriggerState();
}

class _GaplyFadeTriggerState extends State<_GaplyFadeTrigger>
    with GaplyMotionTrigger<_GaplyFadeTrigger, GaplyFade, GaplyFadeWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyFade get style => widget.style;

  @override
  void didUpdateWidget(_GaplyFadeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyFade style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyFadeWidget(key: triggerKey, style: widget.style, child: widget.child);
  }
}
