part of 'gaply_train.dart';

class _GaplyTrainTrigger<T> extends StatefulWidget {
  final T currentItem;
  final T? previousItem;
  final Widget Function(T item) itemBuilder;
  final GaplyTrain style;
  final Object? trigger;

  const _GaplyTrainTrigger({
    super.key,
    required this.currentItem,
    required this.previousItem,
    required this.itemBuilder,
    required this.style,
    this.trigger,
  });

  @override
  State<_GaplyTrainTrigger> createState() => _GaplyTrainTriggerState();
}

class _GaplyTrainTriggerState<T> extends State<_GaplyTrainTrigger<T>>
    with GaplyMotionTrigger<_GaplyTrainTrigger<T>, GaplyTrain, GaplyTrainWidgetState<T>> {
  @override
  Object? get trigger => widget.trigger;

  @override
  GaplyTrain get style => widget.style;

  @override
  void didUpdateWidget(_GaplyTrainTrigger<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    checkAndExecute(oldWidget.style, oldWidget.trigger);
  }

  @override
  void execute(GaplyTrain style) {
    triggerKey.currentState?.executeParams(style);
  }

  @override
  Widget build(BuildContext context) {
    return GaplyTrainWidget<T>(
      key: triggerKey,
      style: widget.style,
      currentItem: widget.currentItem,
      previousItem: widget.previousItem,
      itemBuilder: widget.itemBuilder,
    );
  }
}
