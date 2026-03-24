import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyAnimDemo extends StatefulWidget {
  const GaplyAnimDemo({super.key});

  @override
  State<GaplyAnimDemo> createState() => _GaplyAnimDemoState();
}

class _GaplyAnimDemoState extends State<GaplyAnimDemo> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cardStyle = BoxStyle.preset('animCard')
        .boxScale(_isHovered ? (_isPressed ? 0.95 : 1.08) : 1.0)
        .boxBorderColor(_isHovered ? Colors.blueAccent : Colors.white.withValues(alpha: 0.1))
        .boxElevation(_isHovered ? 40 : 0)
        .boxBlur(_isPressed ? 30 : 20)
        .boxCurve(_isPressed ? Curves.easeOutCubic : Curves.elasticOut);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GaplyBox(style: cardStyle, child: _buildContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          transform: Matrix4.rotationZ(_isHovered ? 0.2 : 0),
          child: const Icon(Icons.bolt, size: 80, color: Colors.blueAccent),
        ),
        const SizedBox(height: 20),
        const Text(
          "Interactive Gaply",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          _isPressed ? "RELEASE TO POP!" : (_isHovered ? "NOW CLICK ME!" : "HOVER ME"),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}
