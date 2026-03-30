part of 'gaply_filter.dart';

class _FilterWidget extends StatelessWidget {
  final GaplyFilter style;
  final Widget child;

  const _FilterWidget({required this.style, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!style.hasEffect) return child;

    return style.profiler.trace(() {
      final colorFilter = style.resolve(context);
      if (colorFilter == null) return child;

      return ColorFiltered(colorFilter: colorFilter, child: child);
    }, tag: 'build');
  }
}
