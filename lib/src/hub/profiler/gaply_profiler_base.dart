import 'package:gaply/src/hub/logger/gaply_logger_base.dart';

import '../logger/gaply_logger.dart';

abstract class GaplyProfilerEngine {
  final GaplyLoggerEngine? customLogger;

  const GaplyProfilerEngine({this.customLogger});

  void record(ProfilePacket packet);
  void printStats(String label);

  Future<void> dispose() async {}

  void debugLog(String text, {bool isForce = false}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.debug, isForce, engineId: customLogger?.id);
  }

  void infoLog(String text, {bool isForce = false}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.info, isForce, engineId: customLogger?.id);
  }

  void warningLog(String text, {bool isForce = true}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.warning, isForce, engineId: customLogger?.id);
  }

  void errorLog(String text, {bool isForce = true}) {
    GaplyLogger.dispatch(text, GaplyLogLevel.error, isForce, engineId: customLogger?.id);
  }
}

abstract class GaplyProfilerStats {
  bool get isNotEmpty;
  DateTime get lastLogTime;

  void flush();
  void printSummary(String label);
}

class ProfilePacket {
  final Duration elapsed;
  final String label;
  final String? tag;
  final bool isAsync;
  final int depth;
  final int memoryDelta;

  ProfilePacket({
    required this.elapsed,
    required this.label,
    this.tag,
    required this.isAsync,
    required this.depth,
    required this.memoryDelta,
  });
}
