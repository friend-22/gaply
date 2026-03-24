part of 'rotate_style.dart';

class _GaplyRotateTrigger extends StatefulWidget {
  final Widget child;
  final RotateStyle style;
  final Object? trigger;

  const _GaplyRotateTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyRotateTrigger> createState() => _GaplyScaleTriggerState();
}

class _GaplyScaleTriggerState extends State<_GaplyRotateTrigger>
    with GaplyMotionTrigger<_GaplyRotateTrigger, RotateStyle, GaplyRotateState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  RotateStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyRotateTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(RotateStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyRotate(key: triggerKey, style: widget.style, child: widget.child);
  }
}
