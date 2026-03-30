part of 'gaply_flip.dart';

class _GaplyFlipTrigger extends StatefulWidget {
  final Widget front;
  final Widget back;
  final GaplyFlip style;
  final Object? trigger;

  const _GaplyFlipTrigger({required this.front, required this.back, required this.style, this.trigger});

  @override
  State<_GaplyFlipTrigger> createState() => _GaplyFlipTriggerState();
}

class _GaplyFlipTriggerState extends State<_GaplyFlipTrigger>
    with GaplyMotionTrigger<_GaplyFlipTrigger, GaplyFlip, GaplyFlipWidgetState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyFlip get style => widget.style;

  @override
  void didUpdateWidget(_GaplyFlipTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyFlip style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyFlipWidget(key: triggerKey, style: widget.style, front: widget.front, back: widget.back);
  }
}
