// import 'dart:ui';
//
// import 'package:features/style/text/spec.dart';
//
// import '../common/animations/spec.dart';
// import '../common/gaply_color.dart';
// import '../common/trigger/shake_trigger.dart';
// import '../common/trigger/translate_trigger.dart';
//
// mixin TextStyleModifierMixin<T> {
//   TextStyleSpec get textSpec;
//
//   T copyWithTextSpec(TextStyleSpec textSpec);
//
//   T _addEffect(TextEffect effect) {
//     final newEffects = Set<TextEffect>.from(textSpec.styles)..add(effect);
//     return copyWithTextSpec(textSpec.copyWith(styles: newEffects));
//   }
//
//   T _removeEffect(TextEffect effect) {
//     final newEffects = Set<TextEffect>.from(textSpec.styles)..remove(effect);
//     return copyWithTextSpec(textSpec.copyWith(styles: newEffects));
//   }
//
//   // 📄 Font Size
//   T fSize(double? value) => copyWithTextSpec(textSpec.copyWith(fontSize: value));
//
//   T tColorParams(GaplyColor? effect) {
//     return copyWithTextSpec(textSpec.copyWith(colorParams: effect));
//   }
//
//   // 📄 Font Size
//   T fColor(Color? value) {
//     return tColorParams(textSpec.colorParams.copyWith(color: value));
//   }
//
//   // 🎨 Color Roles
//   T fColorR(ColorRole value) {
//     return tColorParams(textSpec.colorParams.copyWith(role: value));
//   }
//
//   T get fColorNone => fColorR(ColorRole.none);
//   T get fPrimary => fColorR(ColorRole.primary);
//   T get fDestructive => fColorR(ColorRole.destructive);
//   T get fHint => fColorR(ColorRole.hint);
//   T get fChart1 => fColorR(ColorRole.chart1);
//   T get fChart2 => fColorR(ColorRole.chart2);
//   T get fChart3 => fColorR(ColorRole.chart3);
//   T get fChart4 => fColorR(ColorRole.chart4);
//   T get fChart5 => fColorR(ColorRole.chart5);
//
//   // 🔥 Color Weight
//   T fWeight(ColorWeight value) {
//     return tColorParams(textSpec.colorParams.copyWith(weight: value));
//   }
//
//   T get cwHigh => fWeight(ColorWeight.high);
//   T get cwLow => fWeight(ColorWeight.low);
//   T get cwMedium => fWeight(ColorWeight.medium);
//
//   // ✍️ Style Roles
//   T fStyle(StyleRole value) => copyWithTextSpec(textSpec.copyWith(styleRole: value));
//   T get textNone => fStyle(StyleRole.none);
//   T get sans => fStyle(StyleRole.sans);
//   T get mono => fStyle(StyleRole.mono);
//   T get xSmall => fStyle(StyleRole.xSmall);
//   T get small => fStyle(StyleRole.small);
//   T get base => fStyle(StyleRole.base);
//   T get large => fStyle(StyleRole.large);
//   T get xLarge => fStyle(StyleRole.xLarge);
//   T get x2Large => fStyle(StyleRole.x2Large);
//   T get x3Large => fStyle(StyleRole.x3Large);
//   T get x4Large => fStyle(StyleRole.x4Large);
//   T get x5Large => fStyle(StyleRole.x5Large);
//   T get x6Large => fStyle(StyleRole.x6Large);
//   T get x7Large => fStyle(StyleRole.x7Large);
//   T get x8Large => fStyle(StyleRole.x8Large);
//   T get x9Large => fStyle(StyleRole.x9Large);
//   T get thin => fStyle(StyleRole.thin);
//   T get light => fStyle(StyleRole.light);
//   T get extraLight => fStyle(StyleRole.extraLight);
//   T get normal => fStyle(StyleRole.normal);
//   T get medium => fStyle(StyleRole.medium);
//   T get semiBold => fStyle(StyleRole.semiBold);
//   T get bold => fStyle(StyleRole.bold);
//   T get extraBold => fStyle(StyleRole.extraBold);
//   T get black => fStyle(StyleRole.black);
//   T get italic => fStyle(StyleRole.italic);
//   T get h1 => fStyle(StyleRole.h1);
//   T get h2 => fStyle(StyleRole.h2);
//   T get h3 => fStyle(StyleRole.h3);
//   T get h4 => fStyle(StyleRole.h4);
//   T get p => fStyle(StyleRole.p);
//   T get blockQuote => fStyle(StyleRole.blockQuote);
//   T get inlineCode => fStyle(StyleRole.inlineCode);
//   T get lead => fStyle(StyleRole.lead);
//   T get textLarge => fStyle(StyleRole.textLarge);
//   T get textMuted => fStyle(StyleRole.textMuted);
//   T get textSmall => fStyle(StyleRole.textSmall);
//   T get underline => fStyle(StyleRole.underline);
//
//   // ✂️ Text styles
//   T get behaviorNone => copyWithTextSpec(textSpec.copyWith(styles: const {}));
//   T get fitted => _addEffect(TextEffect.fitted);
//   T get marquee {
//     final newEffects = Set<TextEffect>.from(textSpec.styles)
//       ..remove(TextEffect.ellipsis)
//       ..add(TextEffect.marquee);
//     return copyWithTextSpec(textSpec.copyWith(styles: newEffects));
//   }
//
//   T get glow => _addEffect(TextEffect.glow);
//   T get shimmer => _addEffect(TextEffect.shimmer);
//   T get stopShimmer => _removeEffect(TextEffect.shimmer);
//   T get ellipsis => _addEffect(TextEffect.ellipsis);
//   T get shadow => _addEffect(TextEffect.shadow);
//   T get glass => _addEffect(TextEffect.glass);
//   T get blur => _addEffect(TextEffect.blur);
//
//   // ✂️ Text alignment
//   T fAlignment(TextAlign value) => copyWithTextSpec(textSpec.copyWith(alignRole: value));
//   T get fLeft => fAlignment(TextAlign.left);
//   T get fCenter => fAlignment(TextAlign.center);
//   T get fRight => fAlignment(TextAlign.right);
//   T get fJustify => fAlignment(TextAlign.justify);
//   T get fStart => fAlignment(TextAlign.start);
//   T get fEnd => fAlignment(TextAlign.end);
//
//   // 📦 Shake Effects
//   T tAniParams(AniParam? effect) {
//     return copyWithTextSpec(textSpec.copyWith(aniParam: effect));
//   }
//
//   T tShake(ShakeType newType) {
//     return tAniParams(textSpec.aniParam.copyWith(shakeType: newType));
//   }
//
//   T get tShakeNone => tShake(ShakeType.none);
//   T get tShakeMild => tShake(ShakeType.mild);
//   T get tShakeNormal => tShake(ShakeType.normal);
//   T get tShakeSevere => tShake(ShakeType.severe);
//   T get tShakeAlert => tShake(ShakeType.alert);
//   T get tShakeNod => tShake(ShakeType.nod);
//   T get tShakeCelebrate => tShake(ShakeType.celebrate);
//   T onTShakeComplete(VoidCallback? action) {
//     final newParams = textSpec.aniParam.copyWith(onShakeComplete: action);
//     return copyWithTextSpec(textSpec.copyWith(aniParam: newParams));
//   }
//
//   // 📦 Slide Effects
//   T tSlide(SlideType newType, bool isVisible) {
//     return tAniParams(textSpec.aniParam.copyWith(slideType: newType, isVisible: isVisible));
//   }
//
//   T tSlideVisible(bool isVisible) {
//     return tAniParams(textSpec.aniParam.copyWith(isVisible: isVisible));
//   }
//
//   T get tSlideNone => tSlide(SlideType.none, true);
//   T get tSlideLeftIn => tSlide(SlideType.slideLeft, true);
//   T get tSlideRightIn => tSlide(SlideType.slideRight, true);
//   T get tSlideUpIn => tSlide(SlideType.slideUp, true);
//   T get tSlideDownIn => tSlide(SlideType.slideDown, true);
//   T get tSlideLeftOut => tSlide(SlideType.slideLeft, false);
//   T get tSlideRightOut => tSlide(SlideType.slideRight, false);
//   T get tSlideUpOut => tSlide(SlideType.slideUp, false);
//   T get tSlideDownOut => tSlide(SlideType.slideDown, false);
//   T onTSlideComplete(VoidCallback? action) {
//     final newParams = textSpec.aniParam.copyWith(onSlideComplete: action);
//     return copyWithTextSpec(textSpec.copyWith(aniParam: newParams));
//   }
//
//   // 📦 Animation Sequence
//   T tAnimation(AniSequence newType) {
//     final newParams = textSpec.aniParam.copyWith(sequence: newType);
//     return copyWithTextSpec(textSpec.copyWith(aniParam: newParams));
//   }
//
//   T get tAnimationNone => tAnimation(AniSequence.none);
//   T get tSlideThenShake => tAnimation(AniSequence.slideThenShake);
//   T get tShakeThenSlide => tAnimation(AniSequence.shakeThenSlide);
//   T get tParallel => tAnimation(AniSequence.parallel);
//
//   T _addFeature(FontFeature feature) {
//     final newFeatures = Set<FontFeature>.from(textSpec.features)..add(feature);
//     return copyWithTextSpec(textSpec.copyWith(features: newFeatures));
//   }
//
//   T _replaceFeature({required FontFeature add, FontFeature? remove}) {
//     final newFeatures = Set<FontFeature>.from(textSpec.features);
//     if (remove != null) newFeatures.remove(remove);
//     newFeatures.add(add);
//     return copyWithTextSpec(textSpec.copyWith(features: newFeatures));
//   }
//
//   T get alternative => _addFeature(FontFeature.alternative);
//   T get alternativeFractions => _addFeature(FontFeature.alternativeFractions);
//   T get contextualAlternates => _addFeature(FontFeature.contextualAlternates);
//   T get caseSensitiveForms => _addFeature(FontFeature.caseSensitiveForms);
//   T get denominator => _addFeature(FontFeature.denominator);
//   T get fractions => _addFeature(FontFeature.fractions);
//   T get historicalForms => _addFeature(FontFeature.historicalForms);
//   T get historicalLigatures => _addFeature(FontFeature.historicalLigatures);
//   T get liningFigures => _replaceFeature(add: FontFeature.liningFigures, remove: FontFeature.oldstyleFigures);
//   T get localeAware => _addFeature(FontFeature.localeAware);
//   T get notationalForms => _addFeature(FontFeature.notationalForms);
//   T get numerators => _addFeature(FontFeature.numerators);
//   T get oldstyleFigures =>
//       _replaceFeature(add: FontFeature.oldstyleFigures, remove: FontFeature.liningFigures);
//   T get ordinalForms => _addFeature(FontFeature.ordinalForms);
//   T get proportionalFigures =>
//       _replaceFeature(add: FontFeature.proportionalFigures, remove: FontFeature.tabularFigures);
//   T get randomize => _addFeature(FontFeature.randomize);
//   T get stylisticAlternates => _addFeature(FontFeature.stylisticAlternates);
//   T get scientificInferiors => _addFeature(FontFeature.scientificInferiors);
//   T get subscripts => _addFeature(FontFeature.subscripts);
//   T get superscripts => _addFeature(FontFeature.superscripts);
//   T get swash => _addFeature(FontFeature.swash);
//   T get tabularFigures =>
//       _replaceFeature(add: FontFeature.tabularFigures, remove: FontFeature.proportionalFigures);
//   T get slashedZero => _addFeature(FontFeature.slashedZero);
//   T get noFeatures => copyWithTextSpec(textSpec.copyWith(features: {}));
// }
