part of '../gaply_hub.dart';

abstract class _LoggerEngine {
  GaplyLoggerSpec get spec;
  String? get id => spec.id;

  const _LoggerEngine();

  void write(Uint8List data) {}

  Future<void> flush() async {}
  Future<void> dispose() async {}
}

@immutable
class _LogPacket extends Equatable {
  final GaplyLogLevel level;
  final String text;
  final DateTime timestamp;

  const _LogPacket({required this.level, required this.text, required this.timestamp});

  @override
  List<Object?> get props => [level, text, timestamp];
}
