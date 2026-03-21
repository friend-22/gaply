// abstract class TBoxStyleWidget<T extends TBoxStyleWidget<T>> extends TextStyleWidget<T>
//     with AniStyleMixin, ProgressStyleMixin, BoxStyleMixin, BoxStyleModifierMixin<T> {
//   const TBoxStyleWidget({super.key});
//
//   TBoxStyleSpec get tBoxSpec;
//
//   @override
//   BoxParams get boxSpec => tBoxSpec.params;
//
//   @override
//   TextStyleSpec get textSpec => tBoxSpec.textSpec;
//
//   @override
//   T copyWithBoxSpec(BoxStyleSpec boxSpec) {
//     return copyWithTBoxSpec(tBoxSpec.copyWith(boxSpec: boxSpec));
//   }
//
//   @override
//   T copyWithTextSpec(TextStyleSpec textSpec) {
//     return copyWithTBoxSpec(tBoxSpec.copyWith(textSpec: textSpec));
//   }
//
//   T copyWithTBoxSpec(TBoxStyleSpec boxSpec);
// }
