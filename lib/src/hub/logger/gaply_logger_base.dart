enum GaplyLogLevel { debug, info, warning, error, none }

abstract class GaplyLoggerEngine {
  final String? id;

  const GaplyLoggerEngine({this.id});

  void write(LogPacket packet);
  Future<void> dispose() async {}
}

class LogPacket {
  final String text;
  final bool isForce;
  final GaplyLogLevel level;
  final DateTime timestamp;
  final String? engineId;

  LogPacket({
    required this.text,
    required this.isForce,
    required this.level,
    required this.timestamp,
    this.engineId,
  });
}
