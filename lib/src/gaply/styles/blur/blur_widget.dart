part of 'blur_style.dart';

class _GaplyBlurWidget extends StatelessWidget {
  final BlurStyle style;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;

  const _GaplyBlurWidget({required this.style, required this.child, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if (!style.isEnabled) return child;

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: style.resolve()!,
              child: Container(color: style.color.resolve(context)),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
