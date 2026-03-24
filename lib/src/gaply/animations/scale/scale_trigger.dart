part of 'scale_style.dart';

class _GaplyScaleTrigger extends StatefulWidget {
  final Widget child;
  final ScaleStyle style;
  final Object? trigger;

  const _GaplyScaleTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyScaleTrigger> createState() => _GaplyScaleTriggerState();
}

class _GaplyScaleTriggerState extends State<_GaplyScaleTrigger>
    with GaplyMotionTrigger<_GaplyScaleTrigger, ScaleStyle, GaplyScaleState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  ScaleStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyScaleTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(ScaleStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyScale(key: triggerKey, style: widget.style, child: widget.child);
  }
}
