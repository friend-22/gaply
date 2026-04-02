part of '../gaply_hub.dart';

class GaplyConsoleLogger extends GaplyLoggerEngine {
  @override
  final GaplyConsoleLoggerSpec spec;

  final List<dynamic> _buffer = [];
  Timer? _flushTimer;
  bool _isFlushing = false;

  GaplyConsoleLogger({required this.spec}) {
    _flushTimer = Timer.periodic(spec.flushInterval, (_) => flush());
  }

  @override
  void write(dynamic data) {
    final bool isImmediate = data[LogPktIdx.isImmediate] == 1;

    if (isImmediate) {
      _log(data);
    } else {
      _buffer.add(data);

      if (_buffer.length >= spec.bufferCapacity) flush();
    }
  }

  @override
  Future<void> flush() async {
    if (_isFlushing || _buffer.isEmpty) return;

    try {
      final logsToPrint = List.from(_buffer);
      _buffer.clear();

      for (final data in logsToPrint) {
        _log(data);
      }
    } finally {
      _isFlushing = false;
    }
  }

  void _log(dynamic data) {
    final GaplyLogLevel level = GaplyLogLevel.values[data[LogPktIdx.level]];
    final String text = data[LogPktIdx.text];

    final a = GaplyHub.theme.ansi;
    String prefix = '';

    switch (level) {
      case GaplyLogLevel.error:
        prefix = '${a.error}[ERROR]${a.reset} ';
        break;
      case GaplyLogLevel.warning:
        prefix = '${a.warning}[WARN]${a.reset} ';
        break;
      case GaplyLogLevel.info:
        prefix = '${a.info}[INFO]${a.reset} ';
        break;
      case GaplyLogLevel.debug:
        prefix = '${a.gray}[DEBUG]${a.reset} ';
        break;
      default:
        break;
    }

    debugPrint('$prefix$text');
  }

  @override
  Future<void> dispose() async {
    _flushTimer?.cancel();
    await flush();
  }
}
