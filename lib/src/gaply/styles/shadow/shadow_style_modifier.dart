import 'dart:ui';

import 'package:gaply/src/gaply/styles/color/gaply_color.dart';
import 'gaply_shadow.dart';

mixin ShadowStyleModifier<T> {
  GaplyShadow get shadowStyle;

  T copyWithShadow(GaplyShadow shadows);

  T shadowStyleSet(GaplyShadow shadows) => copyWithShadow(shadows);

  T shadowPreset(String name, {GaplyColor? color}) => copyWithShadow(GaplyShadow.preset(name, color: color));

  T shadowElevation(double value, {GaplyColor? color}) =>
      copyWithShadow(GaplyShadow.elevation(value, color: color));

  T shadowColor(GaplyColor color) => copyWithShadow(shadowStyle.copyWith(color: color));
  T shadowOffset(Offset offset) => copyWithShadow(shadowStyle.copyWith(offset: offset));
  T shadowBlur(double radius) => copyWithShadow(shadowStyle.copyWith(blurRadius: radius));
  T shadowSpread(double radius) => copyWithShadow(shadowStyle.copyWith(spreadRadius: radius));
  T shadowBlurStyle(BlurStyle style) => copyWithShadow(shadowStyle.copyWith(blurStyle: style));
  T shadowRadius(double radius) =>
      copyWithShadow(shadowStyle.copyWith(blurRadius: radius, spreadRadius: radius));

  T shadowIntensity(double factor) {
    return copyWithShadow(
      shadowStyle.copyWith(
        blurRadius: shadowStyle.blurRadius * factor,
        spreadRadius: shadowStyle.spreadRadius * factor,
      ),
    );
  }
}

mixin ManyShadowStyleModifier<T> {
  List<GaplyShadow> get shadowStyle;

  T copyWithManyShadows(List<GaplyShadow> shadows);

  T shadows(List<GaplyShadow> values) => copyWithManyShadows(values);

  T shadowAdd(GaplyShadow shadow) => copyWithManyShadows([...shadowStyle, shadow]);

  T shadowElevation(double value, {GaplyColor? color}) =>
      shadowAdd(GaplyShadow.elevation(value, color: color));

  T shadowColorAt(int index, GaplyColor color) {
    if (index < 0 || index >= shadowStyle.length) return this as T;
    final newShadows = List<GaplyShadow>.from(shadowStyle);
    newShadows[index] = newShadows[index].copyWith(color: color);
    return copyWithManyShadows(newShadows);
  }

  T shadowClear() => copyWithManyShadows(const []);

  T shadowIntensity(double factor) {
    return copyWithManyShadows(shadowStyle.map((s) => s.shadowIntensity(factor)).toList());
  }
}
