import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom [GestureDetector]
/// Fast check for double tap
/// onDoubleTap : call order [onTap, onDoubleTap]
/// double tap check time ms : 250
class TapGestureDetector extends StatefulWidget {
  final Widget? child;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureTapMoveCallback? onTapMove;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapCallback? onSecondaryTap;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureTapDownCallback? onDoubleTapDown;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCancelCallback? onDoubleTapCancel;
  final GestureLongPressDownCallback? onLongPressDown;
  final GestureLongPressCancelCallback? onLongPressCancel;
  final GestureLongPressCallback? onLongPress;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressDownCallback? onSecondaryLongPressDown;
  final GestureLongPressCancelCallback? onSecondaryLongPressCancel;
  final GestureLongPressCallback? onSecondaryLongPress;
  final GestureLongPressStartCallback? onSecondaryLongPressStart;
  final GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;
  final GestureLongPressUpCallback? onSecondaryLongPressUp;
  final GestureLongPressEndCallback? onSecondaryLongPressEnd;
  final GestureLongPressDownCallback? onTertiaryLongPressDown;
  final GestureLongPressCancelCallback? onTertiaryLongPressCancel;
  final GestureLongPressCallback? onTertiaryLongPress;
  final GestureLongPressStartCallback? onTertiaryLongPressStart;
  final GestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate;
  final GestureLongPressUpCallback? onTertiaryLongPressUp;
  final GestureLongPressEndCallback? onTertiaryLongPressEnd;
  final GestureDragDownCallback? onVerticalDragDown;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final GestureDragCancelCallback? onVerticalDragCancel;
  final GestureDragDownCallback? onHorizontalDragDown;
  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragCancelCallback? onHorizontalDragCancel;
  final GestureDragDownCallback? onPanDown;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;

  final GestureDragCancelCallback? onPanCancel;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;

  final GestureForcePressStartCallback? onForcePressStart;
  final GestureForcePressPeakCallback? onForcePressPeak;
  final GestureForcePressUpdateCallback? onForcePressUpdate;
  final GestureForcePressEndCallback? onForcePressEnd;
  final HitTestBehavior? behavior;
  final bool excludeFromSemantics;
  final DragStartBehavior dragStartBehavior;
  final bool trackpadScrollCausesScale;
  final Offset trackpadScrollToScaleFactor;
  final Set<PointerDeviceKind>? supportedDevices;

  const TapGestureDetector({
    super.key,
    this.child,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapMove,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onDoubleTapCancel,
    this.onLongPressDown,
    this.onLongPressCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onSecondaryLongPressDown,
    this.onSecondaryLongPressCancel,
    this.onSecondaryLongPress,
    this.onSecondaryLongPressStart,
    this.onSecondaryLongPressMoveUpdate,
    this.onSecondaryLongPressUp,
    this.onSecondaryLongPressEnd,
    this.onTertiaryLongPressDown,
    this.onTertiaryLongPressCancel,
    this.onTertiaryLongPress,
    this.onTertiaryLongPressStart,
    this.onTertiaryLongPressMoveUpdate,
    this.onTertiaryLongPressUp,
    this.onTertiaryLongPressEnd,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.behavior,
    this.excludeFromSemantics = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.trackpadScrollCausesScale = false,
    this.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
    this.supportedDevices,
  });

  @override
  State<TapGestureDetector> createState() => _TapGestureDetectorState();
}

const int kDoubleTapThresholdMs = 250;

class _TapGestureDetectorState extends State<TapGestureDetector> {
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    final isDoubleTap =
        _lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < kDoubleTapThresholdMs;

    if (isDoubleTap && widget.onDoubleTap != null) {
      widget.onDoubleTap!();
      _lastTapTime = null;
    } else {
      widget.onTap?.call();
      _lastTapTime = now;

      Future.delayed(const Duration(milliseconds: kDoubleTapThresholdMs), () {
        if (mounted) _lastTapTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final useTap = widget.onTap != null || widget.onDoubleTap != null;
    GestureTapCallback? handleTap = useTap ? _handleTap : null;

    return GestureDetector(
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onTap: handleTap,
      onTapMove: widget.onTapMove,
      onTapCancel: widget.onTapCancel,
      onSecondaryTap: widget.onSecondaryTap,
      onSecondaryTapDown: widget.onSecondaryTapDown,
      onSecondaryTapUp: widget.onSecondaryTapUp,
      onSecondaryTapCancel: widget.onSecondaryTapCancel,
      onTertiaryTapDown: widget.onTertiaryTapDown,
      onTertiaryTapUp: widget.onTertiaryTapUp,
      onTertiaryTapCancel: widget.onTertiaryTapCancel,
      onDoubleTapDown: widget.onDoubleTapDown,
      onDoubleTap: null,
      onDoubleTapCancel: widget.onDoubleTapCancel,
      onLongPressDown: widget.onLongPressDown,
      onLongPressCancel: widget.onLongPressCancel,
      onLongPress: widget.onLongPress,
      onLongPressStart: widget.onLongPressStart,
      onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
      onLongPressUp: widget.onLongPressUp,
      onLongPressEnd: widget.onLongPressEnd,
      onSecondaryLongPressDown: widget.onSecondaryLongPressDown,
      onSecondaryLongPressCancel: widget.onSecondaryLongPressCancel,
      onSecondaryLongPress: widget.onSecondaryLongPress,
      onSecondaryLongPressStart: widget.onSecondaryLongPressStart,
      onSecondaryLongPressMoveUpdate: widget.onSecondaryLongPressMoveUpdate,
      onSecondaryLongPressUp: widget.onSecondaryLongPressUp,
      onSecondaryLongPressEnd: widget.onSecondaryLongPressEnd,
      onTertiaryLongPressDown: widget.onTertiaryLongPressDown,
      onTertiaryLongPressCancel: widget.onTertiaryLongPressCancel,
      onTertiaryLongPress: widget.onTertiaryLongPress,
      onTertiaryLongPressStart: widget.onTertiaryLongPressStart,
      onTertiaryLongPressMoveUpdate: widget.onTertiaryLongPressMoveUpdate,
      onTertiaryLongPressUp: widget.onTertiaryLongPressUp,
      onTertiaryLongPressEnd: widget.onTertiaryLongPressEnd,
      onVerticalDragDown: widget.onVerticalDragDown,
      onVerticalDragStart: widget.onVerticalDragStart,
      onVerticalDragUpdate: widget.onVerticalDragUpdate,
      onVerticalDragEnd: widget.onVerticalDragEnd,
      onVerticalDragCancel: widget.onVerticalDragCancel,
      onHorizontalDragDown: widget.onHorizontalDragDown,
      onHorizontalDragStart: widget.onHorizontalDragStart,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      onHorizontalDragCancel: widget.onHorizontalDragCancel,
      onPanDown: widget.onPanDown,
      onPanStart: widget.onPanStart,
      onPanUpdate: widget.onPanUpdate,
      onPanEnd: widget.onPanEnd,
      onPanCancel: widget.onPanCancel,
      onScaleStart: widget.onScaleStart,
      onScaleUpdate: widget.onScaleUpdate,
      onScaleEnd: widget.onScaleEnd,
      onForcePressStart: widget.onForcePressStart,
      onForcePressPeak: widget.onForcePressPeak,
      onForcePressUpdate: widget.onForcePressUpdate,
      onForcePressEnd: widget.onForcePressEnd,
      behavior: widget.behavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      dragStartBehavior: widget.dragStartBehavior,
      trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
      trackpadScrollToScaleFactor: widget.trackpadScrollToScaleFactor,
      supportedDevices: widget.supportedDevices,
      child: widget.child,
    );
  }
}
