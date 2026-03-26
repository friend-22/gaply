import 'package:flutter/material.dart';

import 'gaply_style.dart';

class GaplyTheme<T extends GaplyThemeData<T>> extends InheritedWidget {
  final T data;

  const GaplyTheme({super.key, required this.data, required super.child});

  static T of<T extends GaplyThemeData<T>>(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<GaplyTheme<T>>();
    if (theme == null) throw Exception("GaplyTheme not found in context");
    return theme.data;
  }

  @override
  bool updateShouldNotify(GaplyTheme<T> oldWidget) => data != oldWidget.data;
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
      tween: _ThemeTween<T>(begin: data, end: data),
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
  T lerp(double t) => begin!.lerp(end, t);
}
