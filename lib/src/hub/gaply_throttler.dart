class GaplyIntervalGate {
  DateTime _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// 시간이 지났는지 확인하고, 지났다면 시간을 갱신한 뒤 true를 반환합니다.
  bool checkAndTick(Duration interval) {
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime) < interval) return false;

    _lastUpdateTime = now;
    return true;
  }
}

class GaplyIntervalMsGate {
  final Stopwatch _timer = Stopwatch()..start();
  int? _lastMillis;

  bool checkAndTick(int intervalMs) {
    final now = _timer.elapsedMilliseconds;

    if (_lastMillis != null && (now - _lastMillis! < intervalMs)) {
      return false;
    }

    _lastMillis = now;
    return true;
  }
}

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
