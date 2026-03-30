part of 'gaply_size.dart';

class _GaplySizeTrigger extends StatefulWidget {
  final Widget child;
  final GaplySize style;
  final Object? trigger;

  const _GaplySizeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplySizeTrigger> createState() => _GaplySizeTriggerState();
}

class _GaplySizeTriggerState extends State<_GaplySizeTrigger>
    with GaplyMotionTrigger<_GaplySizeTrigger, GaplySize, GaplySizeWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplySize get style => widget.style;

  @override
  void didUpdateWidget(_GaplySizeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplySize style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplySizeWidget(key: triggerKey, style: widget.style, child: widget.child);
  }
}
