import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyBoxStressTest extends StatefulWidget {
  const GaplyBoxStressTest({super.key});

  @override
  State<GaplyBoxStressTest> createState() => _GaplyBoxStressTestState();
}

class _GaplyBoxStressTestState extends State<GaplyBoxStressTest> {
  bool _active = false;

  final profiler = const GaplyProfiler(label: 'StressBox', enabled: true, thresholdUs: 100);

  final shadowColor = const GaplyColor.fromColor(Colors.blueGrey);
  final blueColor = const GaplyColor.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GaplyBoxWidget(
              gaplyBox: GaplyBox(
                profiler: profiler,
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                layout: GaplyLayout(
                  width: _active ? 300 : 150,
                  height: _active ? 300 : 150,
                  borderRadius: BorderRadius.circular(_active ? 150 : 20),
                ),
                color: GaplyColor(token: _active ? GaplyColorToken.primary : GaplyColorToken.surface),
                // 섀도우 리스트 lerp 부하 테스트
                shadows: [
                  GaplyShadow(
                    color: shadowColor,
                    blurRadius: _active ? 30 : 10,
                    spreadRadius: _active ? 5 : 0,
                  ),
                  if (_active) GaplyShadow(color: blueColor, blurRadius: 50),
                ],
                // 복합 효과들
                noise: GaplyNoise(intensity: _active ? 0.1 : 0),
                blur: GaplyBlur(sigma: _active ? 10 : 0),
                filter: GaplyFilter(grayscale: _active ? 1.0 : 0.0, contrast: _active ? 1.5 : 1.0),
                // motion: GaplyMotion(scale: _active ? 1.2 : 1.0),
              ),
              child: const FlutterLogo(size: 80),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => setState(() => _active = !_active),
              child: const Text("Run Stress Animation"),
            ),
          ],
        ),
      ),
    );
  }
}
