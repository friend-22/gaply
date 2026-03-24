// import 'package:flutter/material.dart';
//
// import 'mixin.dart';
// import 'box_style_modifier.dart';
//
// abstract class TextStyleWidget<T extends TextStyleWidget<T>> extends StatelessWidget
//     with AniStyleMixin, TextStyleMixin, TextStyleModifierMixin<T> {
//   const TextStyleWidget({super.key});
//
//   @override
//   T copyWithTextSpec(TextStyleSpec textSpec);
// }
//
// extension TextStyleModifier<T extends TextStyleWidget<T>> on T {
//   T get maximum => cwHigh.h1;
//   T get title => h4;
//
//   T get modalTitle => h3.fPrimary.glow;
//   T get subTitle => textSmall;
//
//   T get danger => fDestructive.cwHigh;
//   T get success => fPrimary.cwHigh;
//
//   T get badgeGlass => textSmall.cwHigh.glass.fCenter;
// }
