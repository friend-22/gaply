part of 'size_style.dart';

class _GaplySizeTrigger extends StatefulWidget {
  final Widget child;
  final SizeStyle style;
  final Object? trigger;

  const _GaplySizeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplySizeTrigger> createState() => _GaplySizeTriggerState();
}

class _GaplySizeTriggerState extends State<_GaplySizeTrigger>
    with GaplyMotionTrigger<_GaplySizeTrigger, SizeStyle, GaplySizeState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  SizeStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplySizeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(SizeStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplySize(key: triggerKey, style: widget.style, child: widget.child);
  }
}
