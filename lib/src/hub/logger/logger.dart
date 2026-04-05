part of '../gaply_hub.dart';

class _GaplyLogger {
  static const String _channelId = 'GaplyLogger';

  final Map<String, _LoggerEngine> _customEngines = {};
  _CompositeLogger _defaultEngine = _CompositeLogger();

  late GaplyChannel _channel;
  late String _listenerId;

  _GaplyLogger() {
    _channel = GaplyChannelPool.getChannel(_channelId);
    _listenerId = _channel.registerListener((data) {
      if (data is Uint8List) {
        _handleIncomingData(data);
      }
    });
  }

  void _handleIncomingData(Uint8List data) {
    final engineId = GaplyBytesReader(data).readStringOrNull();

    if (engineId != null && _customEngines.containsKey(engineId)) {
      _customEngines[engineId]!.write(data);
    } else {
      _defaultEngine.write(data);
    }
  }

  void addDefaultLogger(GaplyLoggerSpec spec) {
    _defaultEngine = _defaultEngine.addEngine(spec);
  }

  void removeDefaultLogger(GaplyLoggerSpec spec) {
    _defaultEngine = _defaultEngine.removeEngine(spec);
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

  static _LoggerEngine createEngineFactory(GaplyLoggerSpec spec) {
    switch (spec) {
      case GaplyConsoleLoggerSpec s:
        return _ConsoleLogger(spec: s);
      case GaplyFileLoggerSpec s:
        return _FileLogger(spec: s);
      case GaplyMemoryLoggerSpec s:
        return _MemoryLogger(spec: s);
    }
    return const _NoOpLogger();
  }

  Future<void> flush() async {
    await _channel.waitForPendingMessages();
    await _defaultEngine.flush();
    await Future.wait(_customEngines.values.map((e) => e.flush()));
  }

  Future<void> dispose() async {
    await _channel.waitForPendingMessages();
    await _defaultEngine.dispose();
    await Future.wait(_customEngines.values.map((e) => e.dispose()));
    await _channel.dispose();
  }

  void dispatch(Uint8List data) {
    final r = GaplyBytesReader(data);
    final _ = r.readStringOrNull();
    final level = GaplyLogLevel.values[r.readInt()];
    final isImmediate = r.readBool();
    final _ = r.readString();

    if (level.index < _LoggerWorker.logLevel.index && !isImmediate) return;

    final w = GaplyBytesWriter(data);
    w.writeInt(DateTime.now().microsecondsSinceEpoch);

    _channel.sendPacket(_listenerId, w.takeBytes());
  }
}

@immutable
class _NoOpLoggerSpec extends GaplyLoggerSpec {
  const _NoOpLoggerSpec();

  @override
  _NoOpLoggerSpec copyWith({String? id}) {
    return _NoOpLoggerSpec();
  }
}

class _NoOpLogger extends _LoggerEngine {
  @override
  final _NoOpLoggerSpec spec = const _NoOpLoggerSpec();

  const _NoOpLogger();
}

class _CompositeLogger extends _LoggerEngine {
  @override
  final _NoOpLoggerSpec spec = const _NoOpLoggerSpec();

  final List<_LoggerEngine> _engines;

  _CompositeLogger({List<_LoggerEngine>? engines}) : _engines = engines ?? [];

  _CompositeLogger addEngine(GaplyLoggerSpec spec) {
    if (_loggerExists(spec)) return this;

    final engine = _GaplyLogger.createEngineFactory(spec);
    _engines.add(engine);
    return this;
  }

  _CompositeLogger removeEngine(GaplyLoggerSpec spec) {
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
  void write(Uint8List data) {
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
    await Future.wait(_engines.map((l) => l.flush()));
  }
}
