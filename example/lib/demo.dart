import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyDemo extends StatefulWidget {
  const GaplyDemo({super.key});

  @override
  State<GaplyDemo> createState() => _GaplyDemoState();
}

class _GaplyDemoState extends State<GaplyDemo> {
  bool _isHovered = false;
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: GaplyGradient.preset('rainbow').resolve(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("Gaply 최적화 데모"), backgroundColor: Colors.transparent),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [..._buildDemo1()]),
        ),
      ),
    );
  }

  List<Widget> _buildDemo1() {
    return [
      FadeStyle(
        isVisible: _isVisible,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      ).buildWidget(
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: BoxStyle.preset('glassCard')
              .borderColorCustom(_isHovered ? Colors.blueAccent : Colors.white.withValues(alpha: .2))
              .shadowElevation(_isHovered ? 30 : 12)
              .layoutScale(_isHovered ? 1.05 : 1.0)
              .buildWidget(child: _buildCardContent()),
        ),
      ),

      const SizedBox(height: 50),

      ElevatedButton(
        onPressed: () => setState(() => _isVisible = !_isVisible),
        child: Text(_isVisible ? "카드 숨기기" : "카드 보이기"),
      ),
    ];
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              "GAPLY FRAMEWORK",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        const Text(
          "Optimization & Chaining",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          "ImplicitlyAnimatedWidget과 RepaintBoundary가 적용된 최적화된 박스 시스템입니다.",
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
        ),
      ],
    );
  }
}
