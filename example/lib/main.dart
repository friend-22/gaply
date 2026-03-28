import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';
import 'package:path_provider/path_provider.dart';

import 'demo_theme.dart';

// void testColor(String label, GaplyColor start, GaplyColor end, double p) {
//   final tween = start.lerp(end, 0.0);
//   final result = tween.resolveWithProgress(p);
//   print('🧪 [$label] $tween, $result');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // {
  //   final start = GaplyColor.fromColor(Colors.blue);
  //   final end = start.copyWith(opacity: 0.1, shade: GaplyColorShade.s200);
  //   testColor('test1', start, end, 0.5);
  // }
  //
  // {
  //   final start = GaplyColor.fromColor(Colors.orange);
  //   final end = start.copyWith(shade: GaplyColorShade.s900);
  //   testColor('test2', start, end, 0.5);
  // }
  //
  // {
  //   final start = GaplyColor.fromColor(Colors.grey, opacity: GaplyColorOpacity.o30);
  //   final end = start.copyWith(opacity: 0.8, shade: GaplyColorShade.s800);
  //   testColor('test3', start, end, 0.5);
  // }

  final directory = await getApplicationDocumentsDirectory();
  final logPath = '${directory.path}/app_logs.txt';

  GaplyLogger.init([GaplyConsoleLogger(), GaplyFileLogger(logPath, mode: FileMode.write)]);

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

  // 다크 테마 등록
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
