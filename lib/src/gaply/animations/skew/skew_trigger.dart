part of 'gaply_skew.dart';

class _GaplySkewTrigger extends StatefulWidget {
  final Widget child;
  final GaplySkew style;
  final Object? trigger;

  const _GaplySkewTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplySkewTrigger> createState() => _GaplySkewTriggerState();
}

class _GaplySkewTriggerState extends State<_GaplySkewTrigger>
    with GaplyMotionTrigger<_GaplySkewTrigger, GaplySkew, GaplySkewWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplySkew get style => widget.style;

  @override
  void didUpdateWidget(_GaplySkewTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplySkew style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplySkewWidget(key: triggerKey, style: widget.style, child: widget.child);
  }
}
