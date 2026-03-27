import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyThemeDemo extends StatefulWidget {
  const GaplyThemeDemo({super.key});

  @override
  State<GaplyThemeDemo> createState() => _GaplyThemeDemoState();
}

class _GaplyThemeDemoState extends State<GaplyThemeDemo> {
  // 현재 활성화된 테마 이름
  String _currentThemeName = 'light';

  void _toggleTheme() {
    setState(() {
      _currentThemeName = _currentThemeName == 'light' ? 'dark' : 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. GaplyTheme 주입
    return AnimatedGaplyTheme<GaplyColorTheme>(
      data: GaplyColorTheme.preset(_currentThemeName),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: const ThemeTestPage(),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleTheme,
            child: const Icon(Icons.palette),
          ),
        ),
      ),
    );
  }
}

class ThemeTestPage extends StatelessWidget {
  const ThemeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bgStyle = GaplyColor.fromToken(GaplyColorToken.background);
    final primaryStyle = GaplyColor.fromToken(GaplyColorToken.primary);

    final bgColor = bgStyle.resolve(context) ?? Colors.white;
    final primaryColor = primaryStyle.resolve(context) ?? Colors.blue;

    return Container(
      color: bgColor,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Gaply Token System",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildColorBox(context, "o50", primaryStyle.copyWith(opacity: 0.5)),
              _buildColorBox(context, "s200", primaryStyle.copyWith(shade: 0.2)),
              _buildColorBox(context, "Full", primaryStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(BuildContext context, String label, GaplyColor style) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: style.resolve(context), borderRadius: BorderRadius.circular(12)),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
