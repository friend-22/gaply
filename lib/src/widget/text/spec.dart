// import 'dart:ui';
//
// import 'package:equatable/equatable.dart';
// import 'package:gaply/src/core/effect/gaply_color.dart';
//
// enum StyleRole {
//   none,
//   sans,
//   mono,
//   xSmall,
//   small,
//   base,
//   large,
//   xLarge,
//   x2Large,
//   x3Large,
//   x4Large,
//   x5Large,
//   x6Large,
//   x7Large,
//   x8Large,
//   x9Large,
//   thin,
//   light,
//   extraLight,
//   normal,
//   medium,
//   semiBold,
//   bold,
//   extraBold,
//   black,
//   italic,
//   h1,
//   h2,
//   h3,
//   h4,
//   p,
//   blockQuote,
//   inlineCode,
//   lead,
//   textLarge,
//   textSmall,
//   textMuted,
//   underline,
// }
//
// enum FontFeature {
//   none,
//   alternative,
//   alternativeFractions, //분수 표기 시 사선(/) 대신 수평선($\frac{1}{2}$) 형태를 사용하기도 합니다.
//   contextualAlternates, //문맥에 따라 글자 모양을 자동으로 연결합니다. (예: f와 i가 붙을 때 fi 합자로 변환)
//   caseSensitiveForms, //대문자만 사용되는 문장에서 괄호((), [])나 기호의 위치를 대문자 높이에 맞게 중앙으로 살짝 올립니다.
//   //characterVariant,
//   denominator, //분수의 분모 부분에 최적화된 작은 숫자를 사용합니다.
//   fractions, //1/2 같은 텍스트를 실제 분수 형태($\frac{1}{2}$)로 자동 변환합니다.
//   historicalForms, //옛날 문헌에서 쓰던 고전적인 글자 형태나 합자를 사용합니다.
//   historicalLigatures, //옛날 문헌에서 쓰던 고전적인 글자 형태나 합자를 사용합니다.
//   liningFigures, //모든 숫자의 높이를 대문자 키에 맞춰 일정한 바닥선 위에 배치합니다. 현대적인 UI 디자인에 가장 많이 쓰입니다.
//   localeAware, //특정 언어(예: 터키어, 폴란드어)의 문법적 특성에 맞는 글자 모양으로 자동 전환합니다.
//   notationalForms, //원문자(①)나 괄호 문자((a)) 같은 특수 형태를 제공할 때 사용합니다.
//   numerators, //분수의 분자 부분에 최적화된 작은 숫자를 사용합니다.
//   oldstyleFigures, //숫자의 높낮이를 소문자처럼 들쭉날쭉하게 표현합니다. 고전적인 서적 느낌을 줄 때 사용합니다.
//   ordinalForms, //1st, 2nd 같은 서수 표기 시 st, nd를 작게 만들어 상단에 붙여줍니다.
//   proportionalFigures, //숫자의 너비를 글자 모양에 맞게 가변적으로 조절합니다. 일반적인 본문 텍스트에 자연스럽게 어울립니다.
//   randomize, //손글씨 느낌을 주기 위해 동일한 글자라도 모양을 무작위로 조금씩 바꿉니다.
//   stylisticAlternates, //폰트 디자이너가 준비한 대체용 글자 모양(더 화려하거나 단순한 형태)을 사용합니다.
//   scientificInferiors, //화학식 등 과학 표기에 최적화된 아래첨자를 사용합니다.
//   //stylisticSet,
//   subscripts, //윗첨자(예: $x^2$)를 디자인적으로 더 자연스럽게 표현합니다.
//   superscripts, //아래첨자(예: $H_2O$)를 표현합니다.
//   swash, //글자의 꼬리를 길게 빼는 등 화려한 장식용 글자를 적용합니다.
//   tabularFigures, //숫자의 너비를 모두 동일하게 맞춥니다. 수치가 실시간으로 변할 때 텍스트가 좌우로 흔들리지 않게 해주므로 대시보드 구현 시 필수입니다.
//   slashedZero, //숫자 0에 대각선을 그어 알파벳 O와 명확히 구분되게 합니다. 시리얼 번호나 코드 표시 시 유용합니다.
// }
//
// /// marquee 와 ellipsis 동시 사용 못 함
// enum TextEffect { none, fitted, marquee, glow, shimmer, ellipsis, shadow, glass, blur }
//
// class TextStyleSpec extends Equatable {
//   final double? fontSize;
//   final bool forceStrutHeight;
//
//   //base
//   final StyleRole styleRole;
//   final TextAlign alignRole;
//
//   //styles
//   final Set<TextEffect> styles;
//   final GaplyColor colorParams;
//   final AniParam aniParam;
//
//   final Set<FontFeature> features;
//
//   const TextStyleSpec({
//     this.fontSize,
//     this.forceStrutHeight = false,
//     this.styleRole = StyleRole.none,
//     this.alignRole = TextAlign.start,
//     this.styles = const {},
//     this.features = const {},
//     this.colorParams = const GaplyColor(),
//     this.aniParam = const AniParam(),
//   });
//
//   const TextStyleSpec.center({
//     this.fontSize,
//     this.forceStrutHeight = false,
//     this.styleRole = StyleRole.none,
//     this.alignRole = TextAlign.center,
//     this.styles = const {},
//     this.features = const {},
//     this.colorParams = const GaplyColor(),
//     this.aniParam = const AniParam(),
//   });
//
//   const TextStyleSpec.numeric({
//     this.fontSize,
//     this.forceStrutHeight = true,
//     this.styleRole = StyleRole.mono,
//     this.alignRole = TextAlign.center,
//     this.styles = const {},
//     this.features = const {FontFeature.tabularFigures, FontFeature.liningFigures},
//     this.colorParams = const GaplyColor(),
//     this.aniParam = const AniParam(),
//   });
//
//   @override
//   List<Object?> get props => [
//     fontSize,
//     forceStrutHeight,
//     styleRole,
//     alignRole,
//     styles,
//     features,
//     aniParam,
//     colorParams,
//   ];
//
//   TextStyleSpec copyWith({
//     double? fontSize,
//     bool? forceStrutHeight,
//     StyleRole? styleRole,
//     TextAlign? alignRole,
//     Set<TextEffect>? styles,
//     Set<FontFeature>? features,
//     AniParam? aniParam,
//     GaplyColor? colorParams,
//   }) {
//     return TextStyleSpec(
//       fontSize: fontSize ?? this.fontSize,
//       styleRole: styleRole ?? this.styleRole,
//       alignRole: alignRole ?? this.alignRole,
//       styles: styles ?? this.styles,
//       features: features ?? this.features,
//       aniParam: aniParam ?? this.aniParam,
//       colorParams: colorParams ?? this.colorParams,
//     );
//   }
// }
