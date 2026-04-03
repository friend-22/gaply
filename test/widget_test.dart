import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaply/gaply.dart';

import 'profiler_test.dart';

void main() async {
  const GaplyConsoleLoggerSpec(
    id: 'MainConsole',
    flushInterval: Duration(milliseconds: 100),
  ).registerDefault();

  print('DEBUG: start!');
  await profilerTest();

  await Future.delayed(const Duration(seconds: 3));
  await GaplyHub.reportAll();
  await Future.delayed(const Duration(seconds: 5));
  print('DEBUG: end!');
}
