part of 'translate_style.dart';

class _GaplyTranslateTrigger extends StatefulWidget {
  final Widget child;
  final TranslateStyle style;
  final Object? trigger;

  const _GaplyTranslateTrigger({required this.child, required this.style, this.trigger});

  @override
  State<_GaplyTranslateTrigger> createState() => _GaplyTranslateTriggerState();
}

class _GaplyTranslateTriggerState extends State<_GaplyTranslateTrigger>
    with GaplyMotionTrigger<_GaplyTranslateTrigger, TranslateStyle, GaplyTranslateState> {
  @override
  Object? get trigger => widget.trigger;

  @override
  TranslateStyle get style => widget.style;

  @override
  void didUpdateWidget(_GaplyTranslateTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(TranslateStyle style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyTranslate(key: triggerKey, style: widget.style, child: widget.child);
  }
}
