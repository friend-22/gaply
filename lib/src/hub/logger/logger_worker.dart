part of '../gaply_hub.dart';

enum _Oper { add, remove, dispose, dispatch, flush, setTheme, setLevel }

enum _Type { base, custom }

enum _FileMode { append, overwrite }

enum _SpecType { console, file, memory }

class _LoggerWorker {
  static GaplyAnsiTheme theme = GaplyAnsiTheme.dark;
  static GaplyLogLevel logLevel = GaplyLogLevel.debug;
  static GaplyWorker worker = GaplyWorkerPool.getWorker('GaplyLoggerWorker', _entryPoint, _listener);
  static final _GaplyLogger logger = _GaplyLogger();

  static void _entryPoint(dynamic message) {
    if (message is! SendPort) return;

    final mainSendPort = message;

    ReceivePort workerReceivePort = ReceivePort();
    mainSendPort.send(workerReceivePort.sendPort);

    workerReceivePort.listen((data) {
      if (data is Uint8List) {
        final items = GaplyBytesBuilder.unpack(data, count: 1);
        final reader = GaplyBytesReader(items[0]);
        final oper = _Oper.values[reader.readInt()];
        switch (oper) {
          case _Oper.add:
            final type = _Type.values[reader.readInt()];
            final spec = _WorkerHelper.fromSpec(items[1]);
            switch (type) {
              case _Type.base:
                logger.addDefaultLogger(spec);
                break;
              case _Type.custom:
                logger.addCustomLogger(spec);
                break;
            }
            break;
          case _Oper.remove:
            final type = _Type.values[reader.readInt()];
            final spec = _WorkerHelper.fromSpec(items[1]);
            switch (type) {
              case _Type.base:
                logger.removeDefaultLogger(spec);
                break;
              case _Type.custom:
                logger.removeCustomLogger(spec);
            }
            break;
          case _Oper.dispatch:
            logger.dispatch(items[1]);
            break;
          case _Oper.flush:
            logger.flush();
            break;

          case _Oper.dispose:
            logger.dispose();
            break;

          default:
            break;
        }
      }
    });
  }

  static void _listener(dynamic message) {}
}

extension _LoggerWorkerX on _LoggerWorker {
  void setTheme(GaplyAnsiTheme theme) {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.setTheme));
    w.addBytes(_AnsiThemeBytes.toBytes(theme));
    _LoggerWorker.worker.sendPacket(w.takeBytes());
  }

  void setLevel(GaplyLogLevel level) {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.setLevel));
    w.addBytes(_LogLevelBytes.toBytes(level));
    _LoggerWorker.worker.sendPacket(w.takeBytes());
  }

  void _addLogger(_Type type, GaplyLoggerSpec logger) {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.add));
    w.addBytes(_TypeBytes.toBytes(type));
    w.addBytes(_WorkerHelper.toSpec(logger));
    _LoggerWorker.worker.sendPacket(w.takeBytes());
  }

  void _removeLogger(_Type type, GaplyLoggerSpec logger) {
    final w = GaplyBytesWriter();
    w.writeInt(_Oper.remove.index);
    w.writeInt(type.index);
    final header = w.takeBytes();

    final spec = _WorkerHelper.toSpec(logger);

    final packet = GaplyBytesBuilder.pack([header, spec]);
    _LoggerWorker.worker.sendPacket(packet);
  }

  void addDefaultLogger(GaplyLoggerSpec logger) => _addLogger(_Type.base, logger);
  void removeDefaultLogger(GaplyLoggerSpec logger) => _removeLogger(_Type.base, logger);
  void addCustomLogger(GaplyLoggerSpec logger) => _addLogger(_Type.custom, logger);
  void removeCustomLogger(GaplyLoggerSpec logger) => _removeLogger(_Type.custom, logger);

  void flush() {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.flush));
    _LoggerWorker.worker.sendPacket(w.takeBytes());
  }

  Future<void> dispose() async {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.dispose));
    _LoggerWorker.worker.sendPacket(w.takeBytes());

    await _LoggerWorker.worker.dispose();
  }

  void dispatch(String text, GaplyLogLevel level, bool isImmediate, {String? engineId}) {
    final w = GaplyBytesWriter();
    w.addBytes(_OperBytes.toBytes(_Oper.dispatch));
    w.writeStringOrNull(engineId);
    w.addBytes(_LogLevelBytes.toBytes(level));
    w.writeBool(isImmediate);
    w.writeString(text);
    _LoggerWorker.worker.sendPacket(w.takeBytes());
  }
}
