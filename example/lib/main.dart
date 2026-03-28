import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:path_provider/path_provider.dart';

import 'box_stress_test.dart';
import 'color_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final logPath = '${directory.path}/app_logs.txt';

  GaplyLogger.init([GaplyConsoleLogger(), GaplyFileLogger(logPath, mode: FileMode.write)]);

  _setupGaplyThemes();

  runApp(const MaterialApp(home: GaplyBoxStressTest()));
}

void _setupGaplyThemes() {
  final lightTheme = GaplyColorTheme(
    profiler: GaplyProfiler.tracePerfect(label: 'lightTheme'),
    duration: Duration(milliseconds: 1000),
    brightness: Brightness.light,
    colors: {
      GaplyColorToken.primary: const GaplyColor(
        profiler: GaplyProfiler.tracePerfect(label: 'PrimaryColor', filter: GaplyProfilerFilter.slowBad),
        token: GaplyColorToken.primary,
        customColor: Colors.blue,
      ),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Colors.white,
      ),
    },
  );
  GaplyColorTheme.register('light', lightTheme);

  final darkTheme = GaplyColorTheme(
    profiler: GaplyProfiler.tracePerfect(label: 'darkTheme'),
    brightness: Brightness.dark,
    duration: Duration(milliseconds: 1000),
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.cyan),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Color(0xFF121212),
      ),
    },
  );
  GaplyColorTheme.register('dark', darkTheme);
}
