import 'dart:async';
import 'dart:ui';

extension TaskHelper on Object {
  void onMicrotask(VoidCallback callback) => Future.microtask(callback);

  void onNextEvent(VoidCallback callback) => Future(callback);

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

  Future<void> secDelay(double seconds) async {
    await Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()));
  }

  Future<void> milliDelay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
