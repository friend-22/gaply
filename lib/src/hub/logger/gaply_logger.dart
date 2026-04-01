import 'dart:isolate';

import 'gaply_logger_base.dart';

class GaplyLogger {
  static GaplyLogLevel level = GaplyLogLevel.debug;

  static GaplyLogDispatcher dispatcher = GaplyLogDispatcher((packet) {
    if (packet.engineId != null && _customEngines.containsKey(packet.engineId)) {
      _customEngines[packet.engineId!]!.write(packet);
    } else {
      _defaultEngine.write(packet);
    }
  });

  static final Map<String, GaplyLoggerEngine> _customEngines = {};
  static GaplyLoggerEngine _defaultEngine = _GaplyNoOpLogger();

  static void initialize(List<GaplyLoggerEngine> engines) {
    _defaultEngine = GaplyCompositeLogger(engines: engines);
  }

  static void addCustomLogger(GaplyLoggerEngine engine) {
    if (engine.id != null) {
      _customEngines[engine.id!] = engine;
    }
  }

  static Future<void> dispose() async {
    await _defaultEngine.dispose();
    await Future.wait(_customEngines.values.map((e) => e.dispose()));
  }

  static void dispatch(String text, GaplyLogLevel level, bool isForce, {String? engineId}) {
    if (level.index < GaplyLogger.level.index && !isForce) return;

    dispatcher.sendPacket(
      LogPacket(text: text, level: level, isForce: isForce, timestamp: DateTime.now(), engineId: engineId),
    );
  }

  static void info(String text, {bool isForce = false}) => dispatch(text, GaplyLogLevel.info, isForce);
  static void debug(String text, {bool isForce = false}) => dispatch(text, GaplyLogLevel.debug, isForce);
  static void warning(String text, {bool isForce = true}) => dispatch(text, GaplyLogLevel.warning, isForce);
  static void error(String text, {bool isForce = true}) => dispatch(text, GaplyLogLevel.error, isForce);
}

class GaplyLogDispatcher {
  static final ReceivePort _receivePort = ReceivePort();
  static bool _isInitialized = false;
  static SendPort get _sendPort => _receivePort.sendPort;

  GaplyLogDispatcher(Function(LogPacket) onMessage) {
    if (_isInitialized) return;
    _isInitialized = true;

    _receivePort.listen((packet) {
      if (packet is LogPacket) {
        onMessage(packet);
      }
    });
  }

  void sendPacket(LogPacket packet) {
    _sendPort.send(packet);
  }
}

class _GaplyNoOpLogger extends GaplyLoggerEngine {
  const _GaplyNoOpLogger();

  @override
  void write(LogPacket packet) {}
}

class GaplyCompositeLogger extends GaplyLoggerEngine {
  final List<GaplyLoggerEngine> engines;

  const GaplyCompositeLogger({super.id, required this.engines});

  @override
  void write(LogPacket packet) {
    for (var l in engines) {
      l.write(packet);
    }
  }

  @override
  Future<void> dispose() {
    return Future.wait(engines.map((l) => l.dispose()));
  }
}
