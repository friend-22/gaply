part of 'gaply_noise.dart';

class _NoiseWidget extends StatelessWidget {
  final GaplyNoise style;
  final Widget child;

  const _NoiseWidget({required this.style, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!style.hasEffect) return child;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _NoisePainter(
                  intensity: style.intensity,
                  density: style.density,
                  isColored: style.isColored,
                  blendMode: style.blendMode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double intensity;
  final double density;
  final bool isColored;
  final BlendMode blendMode;
  static ui.Image? _cachedNoiseImage;

  _NoisePainter({
    required this.intensity,
    required this.density,
    required this.isColored,
    required this.blendMode,
  });

  @override
  void paint(Canvas canvas, Size size) async {
    if (_cachedNoiseImage == null) {
      _cachedNoiseImage = await _generateNoiseImage();
      return;
    }

    final paint = Paint()
      ..shader = ImageShader(
        _cachedNoiseImage!,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      )
      ..blendMode = blendMode;

    canvas.drawRect(Offset.zero & size, paint);
  }

  Future<ui.Image> _generateNoiseImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final random = math.Random();
    const double size = 128.0;

    for (double i = 0; i < size; i++) {
      for (double j = 0; j < size; j++) {
        final colorValue = random.nextInt(256);
        paint.color = isColored
            ? Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256))
            : Color.fromARGB(255, colorValue, colorValue, colorValue);

        canvas.drawRect(Rect.fromLTWH(i, j, 1, 1), paint);
      }
    }
    final picture = recorder.endRecording();
    return await picture.toImage(size.toInt(), size.toInt());
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) =>
      oldDelegate.intensity != intensity || oldDelegate.isColored != isColored;
}
