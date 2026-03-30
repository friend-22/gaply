import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyColorThemeTest extends StatefulWidget {
  const GaplyColorThemeTest({super.key});

  @override
  State<GaplyColorThemeTest> createState() => _GaplyColorThemeTestState();
}

class _GaplyColorThemeTestState extends State<GaplyColorThemeTest> {
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
    final themeData = GaplyColorTheme.of(_currentThemeName);

    return AnimatedGaplyTheme<GaplyColorTheme>(
      data: themeData,
      child: Builder(
        builder: (innerContext) {
          final theme = GaplyTheme.of<GaplyColorTheme>(innerContext);

          final bgStyle = theme.getColor(GaplyColorToken.background);
          final primaryStyle = theme.getColor(GaplyColorToken.primary);

          final bgColor = bgStyle.resolve(innerContext) ?? Colors.white;
          final primaryColor = primaryStyle.resolve(innerContext) ?? Colors.blue;

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
                      _buildColorBox(context, "o70", primaryStyle.copyWith(opacity: 0.7)),
                      const SizedBox(width: 20),
                      _buildColorBox(context, "s200", primaryStyle.copyWith(shade: 0.2)),
                      const SizedBox(width: 20),
                      _buildColorBox(context, "Full", primaryStyle),
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
    return Container(width: 50, height: 50, color: color);
  }
}
