part of 'gaply_shimmer.dart';

class _ShimmerWidget extends StatelessWidget {
  final GaplyShimmer style;
  final Widget child;

  const _ShimmerWidget({required this.style, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!style.hasEffect) return child;

    return style.profiler.trace(() {
      final baseColor = style.baseColor.resolve(context);
      final highlightColor = style.highlightColor.resolve(context);

      if (baseColor == null || highlightColor == null) return child;

      return Shimmer.fromColors(
        period: style.period,
        direction: style.direction,
        loop: style.loop,
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      );
    }, tag: 'build');
  }
}
