part of '../gaply_hub.dart';

class GaplyMemoryLogger extends GaplyLoggerEngine {
  @override
  final GaplyMemoryLoggerSpec spec;

  final List<String> _logs = [];

  GaplyMemoryLogger({required this.spec});

  @override
  void write(dynamic data) {
    final String text = data[LogPktIdx.text];

    if (_logs.length >= spec.maxCapacity) _logs.removeAt(0);
    _logs.add(text);
  }

  @override
  Future<void> flush() async {
    _logs.clear();
  }

  List<String> get allLogs => List.unmodifiable(_logs);
}
