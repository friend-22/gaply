// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:convert';
import 'dart:io' show FileMode, File, IOSink;

import 'package:flutter/foundation.dart' show debugPrint;

import 'gaply_logger_base.dart';

class GaplyFileLogger extends GaplyLoggerEngine {
  final File file;
  final int maxBytes;
  final FileMode _mode;

  Future<void> _lock = Future.value();
  IOSink? _sink;
  int _currentFileBytes = 0;

  final List<String> _buffer = [];
  Timer? _flushTimer;
  final int bufferCapacity;
  final Duration flushInterval;

  GaplyFileLogger(
    String path, {
    super.id,
    Duration interval = Duration.zero,
    FileMode mode = FileMode.append,
    this.maxBytes = 5 * 1024 * 1024,
    this.bufferCapacity = 20,
    this.flushInterval = const Duration(seconds: 5),
  }) : file = File(path),
       _mode = mode {
    _enqueue(_initLogger);
  }

  void _enqueue(FutureOr<void> Function() task) {
    _lock = _lock.then((_) => task()).catchError((e) {
      debugPrint('❌ GaplyFileLogger Task Error: $e');
    });
  }

  Future<void> _initLogger() async {
    try {
      if (await file.exists()) {
        _currentFileBytes = await file.length();
      } else {
        _currentFileBytes = 0;
      }
      _sink = file.openWrite(mode: _mode, encoding: utf8);
    } catch (e) {
      debugPrint('❌ GaplyFileLogger Init Error: $e');
    }
  }

  @override
  void write(LogPacket packet) {
    if (packet.level.index < GaplyLogLevel.warning.index) return;

    final message = '${packet.timestamp} | [${packet.level.name}] | ${packet.text}';
    _buffer.add(message);

    if (packet.isForce || _buffer.length >= bufferCapacity) {
      _flush();
    } else {
      _flushTimer ??= Timer(flushInterval, _flush);
    }
  }

  void _flush() {
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

      if (_currentFileBytes + bytes.length > maxBytes) {
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

      final oldFile = File('${file.path}.old');
      if (await oldFile.exists()) await oldFile.delete();
      if (await file.exists()) await file.rename(oldFile.path);

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
