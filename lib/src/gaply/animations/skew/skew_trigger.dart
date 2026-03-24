part of 'skew_style.dart';

class _GaplySkewTrigger extends StatefulWidget {
  final Widget child;
  final SkewStyle style;
  final Object? trigger;

  const _GaplySkewTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplySkewTrigger> createState() => _GaplySkewTriggerState();
}

class _GaplySkewTriggerState extends State<_GaplySkewTrigger>
    with GaplyMotionTrigger<_GaplySkewTrigger, SkewStyle, GaplySkewState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  SkewStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplySkewTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(SkewStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplySkew(key: triggerKey, style: widget.style, child: widget.child);
  }
}
