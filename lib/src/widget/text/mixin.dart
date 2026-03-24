// import 'dart:ui';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
//
// import 'spec.dart';
//
// mixin TextStyleMixin on AniStyleMixin {
//   TextStyleSpec get textSpec;
//
//   List<Shadow>? getRoleShadows(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     Color color = textSpec.colorParams.resolve(context) ?? colorScheme.foreground;
//
//     List<Shadow> shadows = [];
//
//     if (textSpec.styles.contains(TextEffect.glow)) {
//       shadows.add(Shadow(blurRadius: 12.0, color: color.withValues(alpha: 0.8), offset: Offset.zero));
//     }
//
//     if (textSpec.styles.contains(TextEffect.shadow)) {
//       shadows.add(
//         Shadow(
//           blurRadius: 5.0,
//           color: colorScheme.foreground.withValues(alpha: 0.5),
//           offset: const Offset(1.5, 1.5),
//         ),
//       );
//     }
//
//     return shadows.isEmpty ? null : shadows;
//   }
//
//   List<ui.FontFeature> uiFeatures(Set<FontFeature> features) {
//     return features.map((f) {
//       return switch (f) {
//         //FontFeature.none => const ui.FontFeature.disable(''),
//         FontFeature.alternative => const ui.FontFeature.alternative(0),
//         FontFeature.alternativeFractions => const ui.FontFeature.alternativeFractions(),
//         FontFeature.contextualAlternates => const ui.FontFeature.contextualAlternates(),
//         FontFeature.caseSensitiveForms => const ui.FontFeature.caseSensitiveForms(),
//         //FontFeature.characterVariant(int value) => ui.FontFeature.characterVariant(value),
//         FontFeature.denominator => const ui.FontFeature.denominator(),
//         FontFeature.fractions => const ui.FontFeature.fractions(),
//         FontFeature.historicalForms => const ui.FontFeature.historicalForms(),
//         FontFeature.historicalLigatures => const ui.FontFeature.historicalLigatures(),
//         FontFeature.liningFigures => const ui.FontFeature.liningFigures(),
//         FontFeature.localeAware => const ui.FontFeature.localeAware(),
//         FontFeature.notationalForms => const ui.FontFeature.notationalForms(),
//         FontFeature.numerators => const ui.FontFeature.numerators(),
//         FontFeature.oldstyleFigures => const ui.FontFeature.oldstyleFigures(),
//         FontFeature.ordinalForms => const ui.FontFeature.ordinalForms(),
//         FontFeature.proportionalFigures => const ui.FontFeature.proportionalFigures(),
//         FontFeature.randomize => const ui.FontFeature.randomize(),
//         FontFeature.stylisticAlternates => const ui.FontFeature.stylisticAlternates(),
//         FontFeature.scientificInferiors => const ui.FontFeature.scientificInferiors(),
//         //FontFeature.stylisticSet(int value) => ui.FontFeature.stylisticSet(value),
//         FontFeature.subscripts => const ui.FontFeature.subscripts(),
//         FontFeature.superscripts => const ui.FontFeature.superscripts(),
//         FontFeature.swash => const ui.FontFeature.swash(),
//         FontFeature.tabularFigures => const ui.FontFeature.tabularFigures(),
//         FontFeature.slashedZero => const ui.FontFeature.slashedZero(),
//         _ => ui.FontFeature.disable(''),
//       };
//     }).toList();
//   }
//
//   TextStyle getStyle(BuildContext context) {
//     final theme = Theme.of(context);
//     final typography = theme.typography;
//
//     final baseStyle = switch (textSpec.styleRole) {
//       StyleRole.sans => typography.sans,
//       StyleRole.mono => typography.mono,
//       StyleRole.xSmall => typography.xSmall,
//       StyleRole.small => typography.small,
//       StyleRole.base => typography.base,
//       StyleRole.large => typography.large,
//       StyleRole.xLarge => typography.xLarge,
//       StyleRole.x2Large => typography.x2Large,
//       StyleRole.x3Large => typography.x3Large,
//       StyleRole.x4Large => typography.x4Large,
//       StyleRole.x5Large => typography.x5Large,
//       StyleRole.x6Large => typography.x6Large,
//       StyleRole.x7Large => typography.x7Large,
//       StyleRole.x8Large => typography.x8Large,
//       StyleRole.x9Large => typography.x9Large,
//       StyleRole.thin => typography.thin,
//       StyleRole.light => typography.light,
//       StyleRole.extraLight => typography.extraLight,
//       StyleRole.normal => typography.normal,
//       StyleRole.medium => typography.medium,
//       StyleRole.semiBold => typography.semiBold,
//       StyleRole.bold => typography.bold,
//       StyleRole.extraBold => typography.extraBold,
//       StyleRole.black => typography.black,
//       StyleRole.italic => typography.italic,
//       StyleRole.h1 => typography.h1,
//       StyleRole.h2 => typography.h2,
//       StyleRole.h3 => typography.h3,
//       StyleRole.h4 => typography.h4,
//       StyleRole.p => typography.p,
//       StyleRole.blockQuote => typography.blockQuote,
//       StyleRole.inlineCode => typography.inlineCode,
//       StyleRole.lead => typography.lead,
//       StyleRole.textLarge => typography.textLarge,
//       StyleRole.textSmall => typography.textSmall,
//       StyleRole.textMuted => typography.textMuted,
//       StyleRole.underline => TextStyle(decoration: TextDecoration.underline),
//       StyleRole.none => const TextStyle(),
//     };
//
//     return baseStyle.copyWith(
//       fontSize: textSpec.fontSize ?? baseStyle.fontSize,
//       color: textSpec.colorParams.resolve(context),
//       shadows: getRoleShadows(context),
//       fontFeatures: uiFeatures(textSpec.features),
//       overflow: textSpec.styles.contains(TextEffect.ellipsis) ? TextOverflow.ellipsis : null,
//     );
//   }
//
//   Widget buildText(BuildContext context, String text) {
//     final style = getStyle(context);
//     final styles = textSpec.styles;
//
//     final strutStyle = textSpec.forceStrutHeight
//         ? StrutStyle(fontSize: style.fontSize, height: style.height ?? 1.2, forceStrutHeight: true)
//         : null;
//
//     Widget current = Text(
//       text,
//       style: style,
//       textAlign: textSpec.alignRole,
//       maxLines: styles.contains(TextEffect.ellipsis) ? 1 : null,
//       strutStyle: strutStyle,
//     );
//
//     // 레이아웃/애니메이션 효과 적용 (순서가 중요함)
//     // 1. Fitted -> 2. Marquee -> 3. Shimmer -> 4. Glass/Blur
//
//     if (styles.contains(TextEffect.fitted)) {
//       current = FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: current);
//     }
//
//     if (styles.contains(TextEffect.marquee)) {
//       if (styles.contains(TextEffect.ellipsis) == false) {
//         current = OverflowMarquee(child: current);
//       }
//     }
//
//     if (styles.contains(TextEffect.shimmer)) {
//       final colorScheme = Theme.of(context).colorScheme;
//       current = Shimmer.fromColors(
//         baseColor: style.color ?? colorScheme.mutedForeground,
//         highlightColor: Colors.white,
//         child: current,
//       );
//     }
//
//     if (styles.contains(TextEffect.blur)) {
//       current = ImageFiltered(
//         imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0, tileMode: TileMode.decal),
//         child: current,
//       );
//     }
//
//     if (styles.contains(TextEffect.glass)) {
//       current = _buildGlassEffect(style.color, current);
//     }
//
//     return current;
//   }
//
//   Widget _buildGlassEffect(Color? baseColor, Widget child) {
//     final color = baseColor ?? Colors.white;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(4),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//           decoration: BoxDecoration(
//             color: color.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(color: color.withValues(alpha: 0.2)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
