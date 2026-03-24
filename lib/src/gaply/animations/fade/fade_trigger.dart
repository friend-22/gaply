part of 'fade_style.dart';

class _GaplyFadeTrigger extends StatefulWidget {
  final Widget child;
  final FadeStyle style;
  final Object? trigger;

  const _GaplyFadeTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyFadeTrigger> createState() => _GaplyFadeTriggerState();
}

class _GaplyFadeTriggerState extends State<_GaplyFadeTrigger>
    with GaplyMotionTrigger<_GaplyFadeTrigger, FadeStyle, GaplyFadeState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  FadeStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyFadeTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(FadeStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyFade(key: triggerKey, style: widget.style, child: widget.child);
  }
}
