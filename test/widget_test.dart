import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaply/gaply.dart';
import 'package:gaply/src/hub/isolate/gaply_isolate.dart';

import 'profiler_test.dart';

void main() async {
  final logPath = './app_logs.txt';

  final console = const GaplyConsoleLoggerSpec(id: 'MainConsole', flushInterval: Duration(milliseconds: 100));
  final file = GaplyFileLoggerSpec(id: 'MainFile', path: logPath);
  console.registerDefault();
  file.registerDefault();

  await GaplyWorkerPool.waitUntilAllReady();

  GaplyHub.info('test info 1', isImmediate: true);
  GaplyHub.warning('test warning 1', isImmediate: true);
  await Future.delayed(const Duration(milliseconds: 50));

  console.removeDefault();
  GaplyHub.info('test info 2', isImmediate: true);
  GaplyHub.warning('test warning 2', isImmediate: true);

  await Future.delayed(const Duration(milliseconds: 50));

  await GaplyHub.dispose();

  print('Gaply Engine Disposed.');
  await Completer<void>().future;
}
