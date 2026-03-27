class Throttler<T> {
  final Duration interval;
  final void Function(T value) onUpdate;
  final bool Function(T oldVal, T newVal)? shouldUpdate;

  T? _lastValue;
  DateTime _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);

  Throttler({required this.interval, required this.onUpdate, this.shouldUpdate});

  factory Throttler.fps(
    int fps, {
    required void Function(T value) onUpdate,
    bool Function(T oldVal, T newVal)? shouldUpdate,
  }) {
    return Throttler(
      interval: Duration(microseconds: 1000000 ~/ fps),
      onUpdate: onUpdate,
      shouldUpdate: shouldUpdate,
    );
  }

  factory Throttler.fps60({
    required void Function(T value) onUpdate,
    bool Function(T oldVal, T newVal)? shouldUpdate,
  }) => Throttler(
    interval: const Duration(microseconds: 16666),
    onUpdate: onUpdate,
    shouldUpdate: shouldUpdate,
  );

  factory Throttler.fps120({
    required void Function(T value) onUpdate,
    bool Function(T oldVal, T newVal)? shouldUpdate,
  }) =>
      Throttler(interval: const Duration(microseconds: 8333), onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  factory Throttler.fps240({
    required void Function(T value) onUpdate,
    bool Function(T oldVal, T newVal)? shouldUpdate,
  }) =>
      Throttler(interval: const Duration(microseconds: 4166), onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  factory Throttler.fpsNano({
    required void Function(T value) onUpdate,
    bool Function(T oldVal, T newVal)? shouldUpdate,
  }) =>
      Throttler(interval: const Duration(microseconds: 2083), onUpdate: onUpdate, shouldUpdate: shouldUpdate);

  void update(T value) {
    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(_lastUpdateTime);

    if (timeSinceLastUpdate < interval) return;

    if (_lastValue != null) {
      final isSignificant = shouldUpdate?.call(_lastValue as T, value) ?? (_lastValue != value);
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
