part of 'gaply_scale.dart';

class _GaplyScaleTrigger extends StatefulWidget {
  final Widget child;
  final GaplyScale style;
  final Object? trigger;

  const _GaplyScaleTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyScaleTrigger> createState() => _GaplyScaleTriggerState();
}

class _GaplyScaleTriggerState extends State<_GaplyScaleTrigger>
    with GaplyMotionTrigger<_GaplyScaleTrigger, GaplyScale, GaplyScaleWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyScale get style => widget.style;

  @override
  void didUpdateWidget(_GaplyScaleTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyScale style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyScaleWidget(key: triggerKey, style: widget.style, child: widget.child);
  }
}
