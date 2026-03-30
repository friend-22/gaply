import 'dart:ui';
import 'package:gaply/src/utils/gaply_profiler.dart';
import 'package:gaply/src/gaply/effects/color/gaply_color.dart';
import 'gaply_shadow.dart';

mixin GaplyShadowModifier<T> {
  GaplyShadow get gaplyShadow;

  T copyWithShadow(GaplyShadow shadows);

  T shadowStyle(GaplyShadow shadows) => copyWithShadow(shadows);

  T shadowOf(Object name, {GaplyProfiler? profiler, GaplyColor? color}) =>
      copyWithShadow(GaplyShadow.of(name, profiler: profiler, color: color));

  T shadowElevation(double value, {GaplyColor? color}) =>
      copyWithShadow(GaplyShadow.elevation(value, color: color));

  T shadowColor(GaplyColor color) => copyWithShadow(gaplyShadow.copyWith(color: color));
  T shadowOffset(Offset offset) => copyWithShadow(gaplyShadow.copyWith(offset: offset));
  T shadowBlur(double radius) => copyWithShadow(gaplyShadow.copyWith(blurRadius: radius));
  T shadowSpread(double radius) => copyWithShadow(gaplyShadow.copyWith(spreadRadius: radius));
  T shadowBlurStyle(BlurStyle style) => copyWithShadow(gaplyShadow.copyWith(blurStyle: style));
  T shadowRadius(double radius) =>
      copyWithShadow(gaplyShadow.copyWith(blurRadius: radius, spreadRadius: radius));

  T shadowIntensity(double factor) {
    return copyWithShadow(
      gaplyShadow.copyWith(
        blurRadius: gaplyShadow.blurRadius * factor,
        spreadRadius: gaplyShadow.spreadRadius * factor,
      ),
    );
  }

  T shadowClear() => copyWithShadow(const GaplyShadow.none());
}

mixin ManyShadowStyleModifier<T> {
  List<GaplyShadow> get shadowStyle;

  T copyWithShadow(List<GaplyShadow> shadows);

  T shadowAll(List<GaplyShadow> values) => copyWithShadow(values);

  T shadowAdd(GaplyShadow shadow) => copyWithShadow([...shadowStyle, shadow]);

  T shadowElevation(double value, {GaplyColor? color}) =>
      shadowAdd(GaplyShadow.elevation(value, color: color));

  T shadowColorAt(int index, GaplyColor color) {
    if (index < 0 || index >= shadowStyle.length) return this as T;
    final newShadows = List<GaplyShadow>.from(shadowStyle);
    newShadows[index] = newShadows[index].copyWith(color: color);
    return copyWithShadow(newShadows);
  }

  T shadowClear() => copyWithShadow(const []);

  T shadowIntensity(double factor) {
    return copyWithShadow(shadowStyle.map((s) => s.shadowIntensity(factor)).toList());
  }
}
