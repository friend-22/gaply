import 'gaply_logger_base.dart';

class GaplyMemoryLogger extends GaplyLoggerEngine {
  final List<String> _logs = [];
  final int maxCapacity;

  GaplyMemoryLogger({super.id, this.maxCapacity = 1000});

  @override
  void write(LogPacket packet) {
    if (_logs.length >= maxCapacity) _logs.removeAt(0);
    _logs.add(packet.text);
  }

  List<String> get allLogs => List.unmodifiable(_logs);
}
