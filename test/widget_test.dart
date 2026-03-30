import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaply/gaply.dart';

void main() {
  //testFade();
  //testColorSystem();
}

void testFade() {
  testWidgets('Fade animation fades in', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GaplyFade(style: GaplyFadeStyle(isVisible: true), child: SizedBox(width: 100, height: 100)),
        ),
      ),
    );

    expect(find.byType(FadeTransition), findsOneWidget);
  });
}

// void testColorSystem() {
//   group('Gaply Color System & Preset Tests', () {
//     // 1. 프리셋 등록 및 조회 테스트
//     test('Should register and retrieve a color theme preset', () {
//       final customTheme = GaplyColorTheme(
//         brightness: Brightness.light,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         colors: {
//           GaplyColorToken.primary: const GaplyColor(token: GaplyColorToken.primary, customColor: Colors.blue),
//         },
//       );
//
//       // 프리셋 등록
//       GaplyColorTheme.register('ocean', customTheme);
//
//       // 프리셋 조회
//       final retrieved = GaplyColorTheme.preset('ocean');
//
//       expect(retrieved.brightness, Brightness.light);
//       expect(retrieved.colors[GaplyColorToken.primary]?.customColor, Colors.blue);
//     });
//
//     // 2. Token Resolve (null 및 타입 체크) 테스트
//     test('GaplyToken should resolve correctly with null or num', () {
//       // Shade resolve
//       expect(GaplyColorShade.resolve(null), GaplyColorShade.s500);
//       expect(GaplyColorShade.resolve(0.1).value, 0.1);
//
//       // Opacity resolve
//       expect(GaplyColorOpacity.resolve(null), GaplyColorOpacity.full);
//       expect(GaplyColorOpacity.resolve(0.5).value, 0.5);
//     });
//
//     // 3. Token 연산자 테스트 (+, -)
//     test('GaplyToken operators should clamp values between 0.0 and 1.0', () {
//       final opacity = GaplyColorOpacity.o80; // 0.8
//
//       expect((opacity + 0.3).value, 1.0); // 1.1 -> 1.0 (Clamp)
//       expect((opacity - 0.9).value, 0.0); // -0.1 -> 0.0 (Clamp)
//     });
//
//     // 4. Color Theme Lerp (애니메이션) 테스트
//     test('GaplyColorTheme should lerp smoothly between two preset', () {
//       final themeA = GaplyColorTheme(
//         brightness: Brightness.light,
//         duration: Duration.zero,
//         curve: Curves.linear,
//         colors: {
//           GaplyColorToken.primary: const GaplyColor(
//             token: GaplyColorToken.primary,
//             opacity: GaplyColorOpacity.transparent, // 0.0
//           ),
//         },
//       );
//
//       final themeB = GaplyColorTheme(
//         brightness: Brightness.light,
//         duration: Duration.zero,
//         curve: Curves.linear,
//         colors: {
//           GaplyColorToken.primary: const GaplyColor(
//             token: GaplyColorToken.primary,
//             opacity: GaplyColorOpacity.full, // 1.0
//           ),
//         },
//       );
//
//       // 중간 지점(t=0.5) 보간 확인
//       final halfTheme = themeA.lerp(themeB, 0.5);
//       final primaryColor = halfTheme.colors[GaplyColorToken.primary];
//
//       expect(primaryColor?.opacity.value, 0.5);
//     });
//
//     // 5. Unknown Preset 에러 메시지 테스트
//     test('Should throw ArgumentError with helpful message for unknown preset', () {
//       expect(
//         () => GaplyColorTheme.preset('non_existent'),
//         throwsA(
//           isA<ArgumentError>().having(
//             (e) => e.message,
//             'message',
//             contains('Unknown GaplyColorTheme preset: \'non_existent\''),
//           ),
//         ),
//       );
//     });
//   });
// }
