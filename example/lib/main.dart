import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:path_provider/path_provider.dart';

import 'demo_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final logPath = '${directory.path}/app_logs.txt';

  GaplyLogger.init([GaplyConsoleLogger(), GaplyFileLogger(logPath, mode: FileMode.write)]);

  GaplyProfiler.showOnlyOverThreshold = true;
  GaplyProfiler.canLogger = true;

  // BoxStyle.register(
  //   'glassCard',
  //   const BoxStyle()
  //       .layoutSize(340, 200)
  //       .layoutPadding(const EdgeInsets.all(24))
  //       .layoutRadius(24)
  //       .layoutBorderWidth(1.5)
  //       .borderColorCustom(Colors.white.withValues(alpha: 0.2))
  //       .blurPreset('apple')
  //       .colorToken(GaplyColorToken.surface, opacity: GaplyColorOpacity.transparent.value)
  //       .shadowElevation(12),
  // );
  //
  // BoxStyle.register(
  //   'animCard',
  //   const BoxStyle()
  //       .layoutSize(300, 300)
  //       .layoutRadius(32)
  //       .layoutPadding(const EdgeInsets.all(24))
  //       .layoutBorderWidth(1)
  //       .colorToken(GaplyColorToken.surface, opacity: GaplyColorOpacity.transparent.value)
  //       .blurPreset('apple')
  //       .borderColorCustom(Colors.white.withValues(alpha: 0.1))
  //       .boxDuration(const Duration(milliseconds: 400))
  //       .boxCurve(Curves.easeOutBack),
  // );

  _setupGaplyThemes();

  runApp(const MaterialApp(home: GaplyThemeDemo()));
}

void _setupGaplyThemes() {
  // 라이트 테마 등록
  final lightTheme = GaplyColorTheme(
    duration: Duration(milliseconds: 500),
    brightness: Brightness.light,
    colors: {
      GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.blue),
      GaplyColorToken.background: const GaplyColor(
        token: GaplyColorToken.background,
        customColor: Colors.white,
      ),
    },
  );
  GaplyColorTheme.register('light', lightTheme);

  // 다크 테마 등록
  final darkTheme = GaplyColorTheme(
    brightness: Brightness.dark,
    duration: Duration(milliseconds: 500),
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
