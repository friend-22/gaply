import 'package:flutter/material.dart';
import 'package:gaply/src/utils/gaply_perf.dart';

import 'gaply_style.dart';

class GaplyTheme<T extends GaplyThemeData<T>> extends InheritedWidget {
  final T data;

  const GaplyTheme({super.key, required this.data, required super.child});

  static T of<T extends GaplyThemeData<T>>(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<GaplyTheme<T>>();
    if (theme == null) throw Exception("GaplyTheme not found in context");
    return theme.data;
  }

  static T? maybeOf<T extends GaplyThemeData<T>>(BuildContext context) {
    return GaplyProfiler.trace240('GaplyTheme.maybeOf<$T>', () {
      final theme = context.dependOnInheritedWidgetOfExactType<GaplyTheme<T>>();
      return theme?.data;
    });
  }

  @override
  bool updateShouldNotify(GaplyTheme<T> oldWidget) {
    final bool changed = data != oldWidget.data;

    // 🔍 [리빌드 추적 로그]
    // changed가 false라면 애니메이션이 돌아가도 화면은 갱신되지 않습니다.
    // debugPrint(
    //   '🔄 [GaplyTheme.updateShouldNotify] '
    //   'Changed: $changed | '
    //   'OldHash: ${oldWidget.data.hashCode} -> NewHash: ${data.hashCode}',
    // );

    return changed;
  }
}

class AnimatedGaplyTheme<T extends GaplyThemeData<T>> extends StatelessWidget {
  final T data;
  final Widget child;

  const AnimatedGaplyTheme({super.key, required this.data, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<T>(
      duration: data.duration,
      curve: data.curve,
      tween: _ThemeTween<T>(end: data),
      builder: (context, animatedTheme, child) {
        return GaplyTheme<T>(data: animatedTheme, child: child!);
      },
      child: child,
    );
  }
}

class _ThemeTween<T extends GaplyThemeData<T>> extends Tween<T> {
  _ThemeTween({super.begin, super.end});

  @override
  T lerp(double t) {
    final result = begin!.lerp(end, t);
    //debugPrint("🎨 Theme Lerping: t = $t");
    return result;
  }
}
