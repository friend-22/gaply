// ignore_for_file: avoid_slow_async_io

part of '../gaply_hub.dart';

class _FileLogger extends _LoggerEngine {
  @override
  final GaplyFileLoggerSpec spec;

  final File _file;
  Future<void> _lock = Future.value();
  IOSink? _sink;
  int _currentFileBytes = 0;

  final List<String> _buffer = [];
  Timer? _flushTimer;

  _FileLogger({required this.spec}) : _file = File(spec.path) {
    _enqueue(_initLogger);
  }

  void _enqueue(FutureOr<void> Function() task) {
    _lock = _lock.then((_) => task()).catchError((e) {
      debugPrint('❌ [Gaply] FileLogger Task Error: $e');
    });
  }

  Future<void> _initLogger() async {
    try {
      final parentDir = _file.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      if (await _file.exists()) {
        _currentFileBytes = await _file.length();
      }
      _sink = _file.openWrite(mode: FileMode.append, encoding: utf8);
    } catch (e) {
      debugPrint('❌ [Gaply] FileLogger Init Error: $e');
    }
  }

  @override
  void write(Uint8List data) {
    final r = GaplyBytesReader(data);

    final _ = r.readStringOrNull();
    final level = GaplyLogLevel.values[r.readInt()];
    final isImmediate = r.readBool();
    final text = r.readString();
    final DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(r.readInt());

    if (level.index < spec.minLevel.index) return;

    final message = '${timestamp.toIso8601String()} | [${level.name.toUpperCase()}] | $text';
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

    _flushTimer?.cancel();
    _flushTimer = null;

    final String content = '${_buffer.join('\n')}\n';
    _buffer.clear();

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
      debugPrint('❌ [Gaply] FileLogger Write Error: $e');
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
      debugPrint('❌ [Gaply] FileLogger Rotation Error: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _flushTimer?.cancel();

    if (_buffer.isNotEmpty) {
      await flush();
    }

    return _lock.then((_) async {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;
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
