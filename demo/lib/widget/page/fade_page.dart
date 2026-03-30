import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyFadeDemo extends StatefulWidget {
  const GaplyFadeDemo({super.key});

  @override
  State<GaplyFadeDemo> createState() => _GaplyFadeDemoState();
}

class _GaplyFadeDemoState extends State<GaplyFadeDemo> {
  bool _isVisible = true;
  int _retriggerCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gaply Fade Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("1. Basic Controls"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                  child: Text(_isVisible ? "Fade Out" : "Fade In"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _retriggerCounter++),
                  child: const Text("Re-trigger Animation"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("2. Fade Presets & Variations"),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                // 기본 Fade In
                _demoBox("Default Fade", const Text("Hello").withFade(GaplyFadeStyle(isVisible: _isVisible))),

                // 느린 등장 (Slow)
                _demoBox(
                  "Slow (1.5s)",
                  const Icon(Icons.favorite, color: Colors.red, size: 40).withFade(
                    GaplyFadeStyle(isVisible: _isVisible, duration: const Duration(milliseconds: 1500)),
                  ),
                ),

                // 커브 적용 (EaseInBack)
                _demoBox(
                  "EaseIn Curve",
                  const FlutterLogo(
                    size: 40,
                  ).withFade(GaplyFadeStyle(isVisible: _isVisible, curve: Curves.easeInQuint)),
                ),

                // 트리거 활용 (누를 때마다 깜빡임)
                _demoBox(
                  "Trigger Reset",
                  const Text(
                    "Reset Me!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).withFade(const GaplyFadeStyle.fadeIn(duration: Duration(milliseconds: 400))),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("3. Staggered Delay (순차 등장)"),

            Column(
              children: List.generate(3, (index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text("Item ${index + 1}"),
                ).withFade(
                  GaplyFadeStyle(
                    isVisible: _isVisible,
                    delay: Duration(milliseconds: index * 200), // 0.2초씩 차이
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _demoBox(String label, Widget child) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
          child: child,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
