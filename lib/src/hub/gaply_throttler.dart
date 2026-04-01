import 'gaply_budget.dart';

class GaplyThrottler<T> {
  final Duration interval;
  final void Function(T value) onUpdate;
  final bool Function(T oldVal, T newVal)? shouldUpdate;

  T? _lastValue;
  DateTime _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);

  GaplyThrottler({required this.interval, required this.onUpdate, this.shouldUpdate});

  void update(T value) {
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime) < interval) return;

    final last = _lastValue;
    if (last != null) {
      final isSignificant = shouldUpdate?.call(last, value) ?? (last != value);
      if (!isSignificant) return;
    }

    _emit(value, now);
  }

  void flush(T value) {
    _emit(value, DateTime.now());
  }

  void _emit(T value, DateTime now) {
    _lastValue = value;
    _lastUpdateTime = now;
    onUpdate(value);
  }

  void reset() {
    _lastValue = null;
    _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);
  }
}

extension GaplyThrottlerShortcuts on GaplyThrottler {
  static GaplyThrottler<T> fps60<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.fps60, onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  static GaplyThrottler<T> fps120<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.fps120, onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  static GaplyThrottler<T> fps240<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.fps240, onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  static GaplyThrottler<T> smooth60<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.smooth60, onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  static GaplyThrottler<T> smooth120<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.smooth120, onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  static GaplyThrottler<T> smooth240<T>({
    required void Function(T value) onUpdate,
    bool Function(T old, T next)? shouldUpdate,
  }) => GaplyThrottler(interval: GaplyBudget.smooth240, onUpdate: onUpdate, shouldUpdate: shouldUpdate);
}
