// part of 'reveal_style.dart';
//
// class _GaplyRevealTrigger extends StatefulWidget {
//   final Widget child;
//   final RevealStyle style;
//   final Object? trigger;
//
//   const _GaplyRevealTrigger({required this.child, required this.style, this.trigger});
//
//   @override
//   State<_GaplyRevealTrigger> createState() => _GaplyScaleTriggerState();
// }
//
// class _GaplyScaleTriggerState extends State<_GaplyRevealTrigger>
//     with GaplyMotionTrigger<_GaplyRevealTrigger, RevealStyle, GaplyRevealState> {
//   @override
//   Object? get trigger => widget.trigger;
//
//   @override
//   RevealStyle get style => widget.style;
//
//   @override
//   void didUpdateWidget(_GaplyRevealTrigger oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     checkAndExecute(oldWidget.style, oldWidget.trigger);
//   }
//
//   @override
//   void execute(RevealStyle style) {
//     triggerKey.currentState?.executeParams(style);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GaplyReveal(key: triggerKey, style: widget.style, child: widget.child);
//   }
// }
