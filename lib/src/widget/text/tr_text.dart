// import 'package:features/features.dart';
// import 'package:features/style/text/gaply_text.dart';
//
// import '../common/tr_mixin.dart';
// import 'base.dart';
//
// class TrText extends TextStyleWidget<TrText> with TrGetter {
//   @override
//   final TextStyleSpec textSpec;
//   @override
//   final String trKey;
//   @override
//   final String? trGroup;
//   @override
//   final List<String>? args;
//   @override
//   final Map<String, String>? namedArgs;
//
//   const TrText(
//     this.trKey, {
//     super.key,
//     this.textSpec = const TextStyleSpec(),
//     this.args,
//     this.namedArgs,
//     this.trGroup = 'ui',
//   });
//
//   const TrText.sub(this.trKey, {super.key, this.textSpec = const TextStyleSpec(), this.args, this.namedArgs})
//     : trGroup = 'ui.sub';
//
//   const TrText.hint(this.trKey, {super.key, this.textSpec = const TextStyleSpec(), this.args, this.namedArgs})
//     : trGroup = 'hint';
//
//   const TrText.field(
//     this.trKey, {
//     super.key,
//     this.textSpec = const TextStyleSpec(),
//     this.args,
//     this.namedArgs,
//   }) : trGroup = 'field';
//
//   const TrText.domain(
//     this.trKey, {
//     super.key,
//     this.textSpec = const TextStyleSpec(),
//     this.args,
//     this.namedArgs,
//   }) : trGroup = 'domain';
//
//   const TrText.setting(
//     this.trKey, {
//     super.key,
//     this.textSpec = const TextStyleSpec(),
//     this.args,
//     this.namedArgs,
//   }) : trGroup = 'setting';
//
//   @override
//   TrText copyWithTextSpec(TextStyleSpec textSpec) =>
//       TrText(trKey, trGroup: trGroup, textSpec: textSpec, args: args, namedArgs: namedArgs);
//
//   @override
//   Widget build(BuildContext context) => applyAnimation(textSpec.aniParam, buildText(context, tr));
// }
