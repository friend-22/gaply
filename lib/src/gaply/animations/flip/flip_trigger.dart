part of 'flip_style.dart';

class _GaplyFlipTrigger extends StatefulWidget {
  final Widget front;
  final Widget back;
  final GaplyFlipStyle style;
  final Object? trigger;

  const _GaplyFlipTrigger({required this.front, required this.back, required this.style, this.trigger});

  @override
  State<_GaplyFlipTrigger> createState() => _GaplyFlipTriggerState();
}

class _GaplyFlipTriggerState extends State<_GaplyFlipTrigger>
    with GaplyMotionTrigger<_GaplyFlipTrigger, GaplyFlipStyle, GaplyFlipState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyFlipStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyFlipTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyFlipStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyFlip(key: triggerKey, style: widget.style, front: widget.front, back: widget.back);
  }
}
