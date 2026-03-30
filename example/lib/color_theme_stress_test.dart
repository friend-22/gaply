import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyColorThemeStressTest extends StatefulWidget {
  const GaplyColorThemeStressTest({super.key});

  @override
  State<GaplyColorThemeStressTest> createState() => _GaplyColorThemeStressTestState();
}

class _GaplyColorThemeStressTestState extends State<GaplyColorThemeStressTest> {
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
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: List.generate(500, (index) {
                    final tokenName = 'token_${index % 1000}';
                    final style = theme.getColor(tokenName);

                    return _buildColorBox(
                      innerContext,
                      "B$index",
                      style.copyWith(shade: (index % 10) / 10.0),
                    );
                  }),
                ),
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
