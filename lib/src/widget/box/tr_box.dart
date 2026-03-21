// import 'package:features/features.dart';
// import 'package:features/style/box/spec.dart';
//
// import '../common/tr_mixin.dart';
// import 'base.dart';
//
// class TrBox extends TBoxStyleWidget<TrBox> with TrGetter {
//   @override
//   final TBoxStyleSpec tBoxSpec;
//
//   @override
//   final String trKey;
//   @override
//   final String? trGroup;
//   @override
//   final List<String>? args;
//   @override
//   final Map<String, String>? namedArgs;
//
//   const TrBox(
//     this.trKey, {
//     super.key,
//     this.tBoxSpec = const TBoxStyleSpec(),
//     this.args,
//     this.namedArgs,
//     this.trGroup = 'ui',
//   });
//
//   const TrBox.sub(this.trKey, {super.key, this.tBoxSpec = const TBoxStyleSpec(), this.args, this.namedArgs})
//     : trGroup = 'ui.sub';
//
//   const TrBox.hint(this.trKey, {super.key, this.tBoxSpec = const TBoxStyleSpec(), this.args, this.namedArgs})
//     : trGroup = 'hint';
//
//   const TrBox.field(this.trKey, {super.key, this.tBoxSpec = const TBoxStyleSpec(), this.args, this.namedArgs})
//     : trGroup = 'field';
//
//   const TrBox.domain(
//     this.trKey, {
//     super.key,
//     this.tBoxSpec = const TBoxStyleSpec(),
//     this.args,
//     this.namedArgs,
//   }) : trGroup = 'domain';
//
//   const TrBox.setting(
//     this.trKey, {
//     super.key,
//     this.tBoxSpec = const TBoxStyleSpec(),
//     this.args,
//     this.namedArgs,
//   }) : trGroup = 'setting';
//
//   @override
//   TrBox copyWithTBoxSpec(TBoxStyleSpec tBoxSpec) =>
//       TrBox(trKey, tBoxSpec: tBoxSpec, trGroup: trGroup, args: args, namedArgs: namedArgs);
//
//   @override
//   Widget build(BuildContext context) => applyAnimation(
//     tBoxSpec.boxSpec.aniParam,
//     buildBox(context, applyAnimation(tBoxSpec.textSpec.aniParam, buildText(context, tr))),
//   );
// }
