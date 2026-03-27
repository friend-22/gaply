import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyThemeDemo extends StatefulWidget {
  const GaplyThemeDemo({super.key});

  @override
  State<GaplyThemeDemo> createState() => _GaplyThemeDemoState();
}

class _GaplyThemeDemoState extends State<GaplyThemeDemo> {
  String _currentThemeName = 'light';

  void _toggleTheme() {
    final oldTheme = _currentThemeName;
    setState(() {
      _currentThemeName = _currentThemeName == 'light' ? 'dark' : 'light';
    });
    GaplyLogger.i('🔄 [THEME_TOGGLED] $oldTheme -> $_currentThemeName');
  }

  @override
  Widget build(BuildContext context) {
    final themeData = GaplyColorTheme.preset(_currentThemeName);

    return AnimatedGaplyTheme<GaplyColorTheme>(
      data: themeData,
      child: Builder(
        builder: (innerContext) {
          final theme = GaplyTheme.of<GaplyColorTheme>(innerContext);

          final bgStyle = theme.getColor(GaplyColorToken.background);
          final primaryStyle = theme.getColor(GaplyColorToken.primary);

          final bgColor = bgStyle.resolve(innerContext) ?? Colors.white;
          final primaryColor = primaryStyle.resolve(innerContext) ?? Colors.blue;

          GaplyLogger.i('primaryColor: ${primaryColor.toARGB32().toRadixString(16)}', isForce: true);

          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("애니메이션 확인 중", style: TextStyle(color: primaryColor, fontSize: 24)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //_buildColorBox(context, "o50", primaryStyle.copyWith(opacity: 0.5)),
                      // const SizedBox(width: 20),
                      _buildColorBox(context, "s200", primaryStyle.copyWith(shade: 0.2)),
                      // const SizedBox(width: 20),
                      // _buildColorBox(context, "Full", primaryStyle),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _toggleTheme,
              child: const Icon(Icons.refresh),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorBox(BuildContext context, String label, GaplyColor style) {
    final color = style.resolve(context) ?? Colors.grey;

    GaplyLogger.i('primaryColor(s200): ${color.toARGB32().toRadixString(16)}', isForce: true);

    return Container(width: 50, height: 50, color: color);
  }
}
