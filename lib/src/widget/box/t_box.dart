// import 'base.dart';
//
// class TBox extends TBoxStyleWidget<TBox> {
//   @override
//   final TBoxStyleSpec tBoxSpec;
//   final String text;
//
//   const TBox(this.text, {super.key, this.tBoxSpec = const TBoxStyleSpec()});
//   const TBox.numeric(this.text, {super.key, this.tBoxSpec = const TBoxStyleSpec.numeric()});
//
//   @override
//   TBox copyWithTBoxSpec(TBoxStyleSpec tBoxSpec) => TBox(text, tBoxSpec: tBoxSpec);
//
//   @override
//   Widget build(BuildContext context) => applyAnimation(
//     tBoxSpec.boxSpec.aniParam,
//     buildBox(context, applyAnimation(tBoxSpec.textSpec.aniParam, buildText(context, text))),
//   );
// }
