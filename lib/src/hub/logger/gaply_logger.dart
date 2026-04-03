part of '../gaply_hub.dart';

class _GaplyLogger {
  static const String _channelId = 'GaplyLogger';
  static GaplyLogLevel level = GaplyLogLevel.debug;
  static late _GaplyLogger _instance;

  final Map<String, GaplyLoggerEngine> _customEngines = {};
  GaplyCompositeLogger _defaultEngine = GaplyCompositeLogger();

  late GaplyChannel _channel;
  late String _listenerId;
  late SendPort _channelPort;

  _GaplyLogger() {
    _channel = GaplyChannelPool.getChannel(_channelId);
    _listenerId = _channel.registerListener(_channelId, (data) {
      if (data is List) {
        _handleIncomingData(data);
      }
    });
    _channelPort = _channel.sendPort;
    _instance = this;
  }

  void _handleIncomingData(dynamic data) {
    if (data is! List) return;

    final String? engineId = data[LoggerIdx.engineId];

    if (engineId != null && _customEngines.containsKey(engineId)) {
      _customEngines[engineId]!.write(data);
    } else {
      _defaultEngine.write(data);
    }
  }

  void addDefaultLogger(GaplyLoggerSpec spec) {
    _defaultEngine = (_defaultEngine).addLogger(spec);
  }

  void removeDefaultLogger(GaplyLoggerSpec spec) {
    _defaultEngine = _defaultEngine.removeLogger(spec);
  }

  void addCustomLogger(GaplyLoggerSpec logger) {
    final id = logger.id;

    if (logger.id == null) {
      GaplyHub.error('⚠️ [Gaply] Custom logger must have an ID.', isImmediate: true);
      return;
    }

    if (_customEngines.containsKey(id)) {
      _customEngines[id]?.dispose();
    }

    _customEngines[logger.id!] = createEngineFactory(logger);
  }

  void removeCustomLogger(GaplyLoggerSpec logger) {
    final id = logger.id;
    if (id == null) return;

    final engine = _customEngines.remove(id);
    engine?.dispose();
  }

  static GaplyLoggerEngine createEngineFactory(GaplyLoggerSpec spec) {
    switch (spec) {
      case GaplyConsoleLoggerSpec s:
        return GaplyConsoleLogger(spec: s);
      case GaplyFileLoggerSpec s:
        return GaplyFileLogger(spec: s);
      case GaplyMemoryLoggerSpec s:
        return GaplyMemoryLogger(spec: s);
    }
    return const _GaplyNoOpLogger();
  }

  Future<void> dispose() async {
    await _channel.waitForPendingMessages();
    await _defaultEngine.dispose();
    await Future.wait(_customEngines.values.map((e) => e.dispose()));
    GaplyChannelPool.removeChannel(_channelId);
  }

  void dispatch(String text, GaplyLogLevel level, bool isImmediate, {String? engineId}) {
    if (level.index < _GaplyLogger.level.index && !isImmediate) return;

    final List<dynamic> logData = [
      text, // LoggerIdx.text
      isImmediate ? 1 : 0, // LoggerIdx.isImmediate
      level.index, // LoggerIdx.level (int가 전송에 유리)
      DateTime.now().microsecondsSinceEpoch, // LoggerIdx.timestamp
      engineId, // LoggerIdx.engineId
    ];

    _channelPort.sendPacket(_listenerId, logData);
  }

  static Future<void> waitForPendingMessages() async {
    await _instance._channel.waitForPendingMessages();
  }
}

class _GaplyNoOpLogger extends GaplyLoggerEngine {
  @override
  final GaplyNoOpLoggerSpec spec = const GaplyNoOpLoggerSpec();

  const _GaplyNoOpLogger();
}

class GaplyCompositeLogger extends GaplyLoggerEngine {
  @override
  final GaplyNoOpLoggerSpec spec = const GaplyNoOpLoggerSpec();

  final List<GaplyLoggerEngine> _engines;

  GaplyCompositeLogger({List<GaplyLoggerEngine>? engines}) : _engines = engines ?? [];

  GaplyCompositeLogger addLogger(GaplyLoggerSpec spec) {
    if (_loggerExists(spec)) return this;

    final engine = _GaplyLogger.createEngineFactory(spec);
    _engines.add(engine);
    return this;
  }

  GaplyCompositeLogger removeLogger(GaplyLoggerSpec spec) {
    _engines.removeWhere((e) {
      if (e.spec.id != null && spec.id != null) return e.spec.id == spec.id;
      return e.spec.runtimeType == spec.runtimeType;
    });
    return this;
  }

  bool _loggerExists(GaplyLoggerSpec spec) {
    return _engines.any((e) {
      if (e.spec.id != null && spec.id != null) {
        return e.spec.id == spec.id;
      }

      return e.spec.runtimeType == spec.runtimeType;
    });
  }

  @override
  void write(dynamic data) {
    for (var l in _engines) {
      l.write(data);
    }
  }

  @override
  Future<void> dispose() {
    return Future.wait(_engines.map((l) => l.dispose()));
  }

  @override
  Future<void> flush() async {
    await _GaplyLogger.waitForPendingMessages();
    await Future.wait(_engines.map((l) => l.flush()));
  }
}
