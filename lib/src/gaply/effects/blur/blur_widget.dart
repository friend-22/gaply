part of 'gaply_blur.dart';

class _BlurWidget extends StatelessWidget {
  final GaplyBlur style;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;

  const _BlurWidget({required this.style, required this.child, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if (!style.hasEffect) return child;

    return style.profiler.trace(() {
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
    }, tag: 'build');
  }
}
