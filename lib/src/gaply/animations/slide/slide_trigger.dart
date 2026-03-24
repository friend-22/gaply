part of 'slide_style.dart';

class _GaplySlideTrigger extends StatefulWidget {
  final Widget child;
  final SlideStyle style;
  final Object? trigger;

  const _GaplySlideTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplySlideTrigger> createState() => _GaplySlideTriggerState();
}

class _GaplySlideTriggerState extends State<_GaplySlideTrigger>
    with GaplyMotionTrigger<_GaplySlideTrigger, SlideStyle, GaplySlideState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  SlideStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplySlideTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(SlideStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplySlide(key: triggerKey, style: widget.style, child: widget.child);
  }
}
