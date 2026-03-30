import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:path_provider/path_provider.dart';

import 'box_stress_test.dart';
import 'color_theme_stress_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final logPath = '${directory.path}/app_logs.txt';

  GaplyLogger.init([GaplyConsoleLogger(), GaplyFileLogger(logPath, mode: FileMode.write)]);

  _setupGaplyThemes();

  GaplyFade.preset.add('fadeIn', GaplyFade.fadeIn());

  runApp(const MaterialApp(home: GaplyColorThemeStressTest()));
}

Map<GaplyColorToken, GaplyColor> _generateStressTestColors(bool isDark) {
  return Map.fromIterable(
    List.generate(1000, (i) => 'token_$i'),
    key: (item) => GaplyColorToken.resolve(item),
    value: (item) {
      final r = (item.hashCode & 0xFF0000) >> 16;
      final g = (item.hashCode & 0x00FF00) >> 8;
      final b = (item.hashCode & 0x0000FF);

      return GaplyColor(
        token: GaplyColorToken.resolve(item),
        customColor: Color.fromARGB(255, r, g, b).withValues(
          alpha: 1.0,
          red: isDark ? r * 0.5 : r.toDouble(),
          green: isDark ? g * 0.5 : g.toDouble(),
          blue: isDark ? b * 0.5 : b.toDouble(),
        ),
      );
    },
  );
}

void _setupGaplyThemes() {
  final lightTheme = GaplyColorTheme(
    profiler: GaplyProfiler.perfect(label: 'Theme_Transition'),
    duration: Duration(milliseconds: 1000),
    brightness: Brightness.light,
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.blue),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Colors.white,
      ),
      ..._generateStressTestColors(false),
    },
  );
  GaplyColorTheme.preset.add('light', lightTheme);

  final darkTheme = GaplyColorTheme(
    profiler: GaplyProfiler.perfect(label: 'darkTheme'),
    brightness: Brightness.dark,
    duration: Duration(milliseconds: 1000),
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.cyan),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Color(0xFF121212),
      ),
      ..._generateStressTestColors(true),
    },
  );
  GaplyColorTheme.preset.add('dark', darkTheme);
}
