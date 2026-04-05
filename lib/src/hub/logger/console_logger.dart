part of '../gaply_hub.dart';

class _ConsoleLogger extends _LoggerEngine {
  @override
  final GaplyConsoleLoggerSpec spec;

  final List<_LogPacket> _buffer = [];
  Timer? _flushTimer;
  bool _isFlushing = false;

  _ConsoleLogger({required this.spec}) {
    _flushTimer = Timer.periodic(spec.flushInterval, (_) => flush());
  }

  @override
  void write(Uint8List data) {
    final r = GaplyBytesReader(data);

    final _ = r.readStringOrNull();
    final level = GaplyLogLevel.values[r.readInt()];
    final isImmediate = r.readBool();
    final text = r.readString();
    final DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(r.readInt());

    final packet = _LogPacket(level: level, text: text, timestamp: timestamp);

    if (isImmediate) {
      _log(packet);
    } else {
      _buffer.add(packet);

      if (_buffer.length >= spec.bufferCapacity) flush();
    }
  }

  @override
  Future<void> flush() async {
    if (_isFlushing || _buffer.isEmpty) return;
    _isFlushing = true;

    try {
      final logsToPrint = List<_LogPacket>.from(_buffer);
      _buffer.clear();

      for (final data in logsToPrint) {
        _log(data);
      }
    } finally {
      _isFlushing = false;
    }
  }

  void _log(_LogPacket p) {
    final a = _LoggerWorker.theme.ansi;
    String prefix = '';

    switch (p.level) {
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

    switch (spec.outputMode) {
      case ConsoleOutputMode.debugPrint:
        debugPrint('$prefix${p.text}');
        break;
      case ConsoleOutputMode.stdout:
        stdout.writeln('$prefix${p.text}');
        break;
    }
  }

  @override
  Future<void> dispose() async {
    _flushTimer?.cancel();
    await flush();
  }
}
