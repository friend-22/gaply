// ignore_for_file: avoid_slow_async_io

part of '../gaply_hub.dart';

class GaplyFileLogger extends GaplyLoggerEngine {
  @override
  final GaplyFileLoggerSpec spec;

  final File _file;
  Future<void> _lock = Future.value();
  IOSink? _sink;
  int _currentFileBytes = 0;

  final List<String> _buffer = [];
  Timer? _flushTimer;

  GaplyFileLogger({required this.spec}) : _file = File(spec.path) {
    _enqueue(_initLogger);
  }

  void _enqueue(FutureOr<void> Function() task) {
    _lock = _lock.then((_) => task()).catchError((e) {
      debugPrint('❌ GaplyFileLogger Task Error: $e');
    });
  }

  Future<void> _initLogger() async {
    try {
      if (await _file.exists()) {
        _currentFileBytes = await _file.length();
      } else {
        _currentFileBytes = 0;
      }
      _sink = _file.openWrite(mode: spec.mode, encoding: utf8);
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Init Error: $e');
    }
  }

  @override
  void write(dynamic data) {
    final String text = data[LogPktIdx.text];
    final bool isImmediate = data[LogPktIdx.isImmediate] == 1;
    final GaplyLogLevel level = GaplyLogLevel.values[data[LogPktIdx.level]];
    final DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(data[LogPktIdx.timestamp]);

    if (level.index < GaplyLogLevel.warning.index) return;

    final message = '$timestamp | [${level.name}] | $text';
    _buffer.add(message);

    if (isImmediate || _buffer.length >= spec.bufferCapacity) {
      flush();
    } else {
      _flushTimer ??= Timer(spec.flushInterval, flush);
    }
  }

  @override
  Future<void> flush() async {
    if (_buffer.isEmpty) return;

    final String content = '${_buffer.join('\n')}\n';
    _buffer.clear();
    _flushTimer?.cancel();
    _flushTimer = null;

    _enqueue(() => _writeAsync(content));
  }

  Future<void> _writeAsync(String content) async {
    if (_sink == null) return;

    try {
      final List<int> bytes = utf8.encode(content);

      if (_currentFileBytes + bytes.length > spec.maxBytes) {
        await _rotateFileAsync();
      }

      _sink?.add(bytes);
      _currentFileBytes += bytes.length;
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Write Error: $e');
    }
  }

  Future<void> _rotateFileAsync() async {
    try {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;

      final oldFile = File('${_file.path}.old');
      if (await oldFile.exists()) await oldFile.delete();
      if (await _file.exists()) await _file.rename(oldFile.path);

      _currentFileBytes = 0;
      await _initLogger();
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Rotation Error: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _lock.then((_) async {
      await _sink?.flush();
      await _sink?.close();
    });
  }

  // Future<String?> readAllLogs() async {
  //   if (!await file.exists()) return null;
  //   return await file.readAsString();
  // }
  //
  // Future<List<File>> getLogFiles() async {
  //   final List<File> files = [file];
  //   final oldFile = File('${file.path}.old');
  //   if (await oldFile.exists()) files.add(oldFile);
  //   return files;
  // }
}
