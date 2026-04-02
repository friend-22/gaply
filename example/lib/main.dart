import 'dart:io';

import 'package:example/profiler_bundle.dart';
import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:path_provider/path_provider.dart';

import 'box_stress_test.dart';
import 'color_theme_stress_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final directory = await getApplicationDocumentsDirectory();
  // final logPath = '${directory.path}/app_logs.txt';

  GaplyBlurToken.add('key');

  final aa = GaplyBlurToken.resolve('key');

  GaplyHub.theme = GaplyAnsiTheme.dark;
  GaplyHub.addDefaultLogger(const GaplyConsoleLoggerSpec());

  _setupGaplyThemes();

  runApp(const MaterialApp(home: GaplyColorThemeStressTest()));

  await GaplyHub.dispose();
}

final List<GaplyColorToken> _stressTokenNames = List.generate(
  1000,
  (i) => GaplyColorToken.resolve('token_$i'),
);

final Map<GaplyColorToken, GaplyColor> _lightColorCache = _generateStressTestColors(false);
final Map<GaplyColorToken, GaplyColor> _darkColorCache = _generateStressTestColors(true);

Map<GaplyColorToken, GaplyColor> _generateStressTestColors(bool isDark) {
  final Map<GaplyColorToken, GaplyColor> result = {};

  for (final token in _stressTokenNames) {
    final hash = token.hashCode;

    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);

    result[token] = GaplyColor(
      token: token,
      customColor: Color.fromARGB(255, r, g, b).withValues(
        alpha: 1.0,
        red: isDark ? r * 0.5 : r.toDouble(),
        green: isDark ? g * 0.5 : g.toDouble(),
        blue: isDark ? b * 0.5 : b.toDouble(),
      ),
    );
  }
  return result;
}

void _setupGaplyThemes() {
  final lightTheme = GaplyColorTheme(
    profiler: ProfilerBundle.lightProfiler,
    duration: Duration(milliseconds: 1000),
    brightness: Brightness.light,
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.blue),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Colors.white,
      ),
      ..._lightColorCache,
    },
  );
  GaplyColorTheme.preset.add('light', lightTheme);

  final darkTheme = GaplyColorTheme(
    profiler: ProfilerBundle.darkProfiler,
    brightness: Brightness.dark,
    duration: Duration(milliseconds: 1000),
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.cyan),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Color(0xFF121212),
      ),
      ..._darkColorCache,
    },
  );
  GaplyColorTheme.preset.add('dark', darkTheme);
}
