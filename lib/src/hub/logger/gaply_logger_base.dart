part of '../gaply_hub.dart';

enum GaplyLogLevel { debug, info, warning, error, none }

abstract class GaplyLoggerEngine {
  GaplyLoggerSpec get spec;
  String? get id => spec.id;

  const GaplyLoggerEngine();

  void write(dynamic data);
  Future<void> dispose() async {}
}

abstract class LogPktIdx {
  static const int text = 0;
  static const int isImmediate = 1;
  static const int level = 2;
  static const int timestamp = 3;
  static const int engineId = 4;
}

//
// @immutable
// class LogPacket extends Equatable {
//   final String text;
//   final bool isImmediate;
//   final GaplyLogLevel level;
//   final DateTime timestamp;
//   final String? engineId;
//
//   const LogPacket({
//     required this.text,
//     required this.isImmediate,
//     required this.level,
//     required this.timestamp,
//     this.engineId,
//   });
//
//   @override
//   List<Object?> get props => [...super.props, text, isImmediate, level, timestamp, engineId];
// }
