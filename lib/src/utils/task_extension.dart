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
    Future.delayed(duration, callback);
  }

  void onSecDelay(double seconds, VoidCallback callback) {
    Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()), callback);
  }

  void onMilliDelay(int milliseconds, VoidCallback callback) {
    Future.delayed(Duration(milliseconds: milliseconds), callback);
  }

  Future<void> delay(Duration duration) async {
    await Future.delayed(duration);
  }

  Future<void> delaySec(double seconds) async {
    await Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()));
  }

  Future<void> delayMilli(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
