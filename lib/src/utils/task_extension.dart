import 'dart:async';

import 'package:flutter/widgets.dart';

extension TaskHelper on Object {
  Future<void> get microtask {
    final completer = Completer<void>();
    Future.microtask(() => completer.complete());
    return completer.future;
  }

  Future<void> get nextEvent {
    final completer = Completer<void>();
    Future(() => completer.complete());
    return completer.future;
  }

  Future<void> get nextRender {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    return completer.future;
  }

  void onMicrotask(VoidCallback callback) => Future.microtask(callback);

  void onNextEvent(VoidCallback callback) => Future(callback);

  void onNextRender(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void onDelay(Duration duration, VoidCallback callback) {
    if (duration == Duration.zero) {
      callback();
    } else {
      Future.delayed(duration, callback);
    }
  }

  void onSecDelay(double seconds, VoidCallback callback) {
    if (seconds == 0.0) {
      callback();
    } else {
      Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()), callback);
    }
  }

  void onMilliDelay(int milliseconds, VoidCallback callback) {
    if (milliseconds == 0) {
      callback();
    } else {
      Future.delayed(Duration(milliseconds: milliseconds), callback);
    }
  }

  Future<void> delay(Duration duration) async {
    if (duration == Duration.zero) return;

    await Future.delayed(duration);
  }

  Future<void> delaySec(double seconds) async {
    if (seconds == 0.0) return;

    await Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()));
  }

  Future<void> delayMilli(int milliseconds) async {
    if (milliseconds == 0) return;

    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
