import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum GaplyLogLevel { debug, info, warning, error, none }

abstract class GaplyLoggerEngine {
  final String? id;

  const GaplyLoggerEngine({this.id});

  void write(LogPacket packet);
  Future<void> dispose() async {}
}

sdlfkjslkdjflksjdf
@immutable
class LogPacket extends Equatable {
  final String text;
  final bool isForce;
  final GaplyLogLevel level;
  final DateTime timestamp;
  final String? engineId;

  const LogPacket({
    required this.text,
    required this.isForce,
    required this.level,
    required this.timestamp,
    this.engineId,
  });

  @override
  List<Object?> get props => [text, isForce, level, timestamp, engineId];
}
