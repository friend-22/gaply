part of '../gaply_hub.dart';

class _MemoryLogger extends _LoggerEngine {
  @override
  final GaplyMemoryLoggerSpec spec;

  final ListQueue<_LogPacket> _logs = ListQueue();

  _MemoryLogger({required this.spec});

  @override
  void write(Uint8List data) {
    final r = GaplyBytesReader(data);

    final _ = r.readStringOrNull();
    final level = GaplyLogLevel.values[r.readInt()];
    final _ = r.readBool();
    final text = r.readString();
    final DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(r.readInt());

    final packet = _LogPacket(level: level, text: text, timestamp: timestamp);

    if (_logs.length >= spec.maxCapacity) {
      _logs.removeFirst();
    }

    _logs.add(packet);
  }

  List<String> get allLogs => List.unmodifiable(_logs);

  List<_LogPacket> getLogsByLevel(GaplyLogLevel minLevel) {
    return _logs.where((l) => l.level.index >= minLevel.index).toList();
  }

  @override
  Future<void> flush() async {
    _logs.clear();
  }
}
