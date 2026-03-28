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
    final theme = context.dependOnInheritedWidgetOfExactType<GaplyTheme<T>>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(GaplyTheme<T> oldWidget) {
    // final bool changed = data != oldWidget.data || data.hashCode != oldWidget.data.hashCode;
    //
    // // 🔍 [리빌드 추적 로그]
    // // changed가 false라면 애니메이션이 돌아가도 화면은 갱신되지 않습니다.
    // GaplyLogger.i(
    //   '🔄 [GaplyTheme.updateShouldNotify] '
    //   'Changed: $changed | '
    //   'OldHash: ${oldWidget.data.hashCode} -> NewHash: ${data.hashCode}',
    // );

    return true;
  }
}

class AnimatedGaplyTheme<T extends GaplyThemeData<T>> extends StatefulWidget {
  final T data;
  final Widget child;
  final Duration? duration;
  final Curve? curve;

  const AnimatedGaplyTheme({super.key, required this.data, required this.child, this.duration, this.curve});

  @override
  State<AnimatedGaplyTheme<T>> createState() => _AnimatedGaplyThemeState<T>();
}

class _AnimatedGaplyThemeState<T extends GaplyThemeData<T>> extends State<AnimatedGaplyTheme<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<T> _animation;
  late T _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.data;

    _controller = AnimationController(duration: widget.duration ?? widget.data.duration, vsync: this);

    _animation = _ThemeTween<T>(begin: _currentTheme, end: widget.data).animate(_controller);

    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(AnimatedGaplyTheme<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      final T startTheme = _animation.value;

      _animation = _ThemeTween<T>(
        begin: startTheme,
        end: widget.data,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve ?? widget.data.curve));

      _controller.duration = widget.duration ?? widget.data.duration;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GaplyLogger.i('💓 HEARTBEAT: ${_controller.value.toStringAsFixed(3)}', isForce: true);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _currentTheme = _animation.value; // ✅ 현재 값 업데이트

        // GaplyLogger.i('[_AnimatedGaplyThemeState.build]');

        return GaplyTheme<T>(data: _currentTheme, child: widget.child);
      },
      //child: widget.child,
    );
  }
}

class _ThemeTween<T extends GaplyThemeData<T>> extends Tween<T> {
  _ThemeTween({super.begin, super.end});

  @override
  T lerp(double t) {
    // GaplyLogger.i('🧬 TWEEN LERP: t=${t.toStringAsFixed(3)}', isForce: true);

    if (begin == null || end == null) return (begin ?? end)!;

    final result = begin!.lerp(end, t);
    // GaplyLogger.i(
    //   '🎨 [Theme.lerp] t: ${t.toStringAsFixed(3)} | '
    //   'from: ${begin.runtimeType} to: ${end.runtimeType}',
    //   isForce: true,
    // );
    return result;
  }
}
