// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gaply/gaply.dart';

void main() {
  testWidgets('Gaply 시퀀스 애니메이션 콜백 순서 및 완료 테스트', (WidgetTester tester) async {
    List<String> logs = [];

    final complexAnim = GaplyMotion(
      animations: [
        ShakeStyle(duration: const Duration(milliseconds: 200)).copyWith(onComplete: () => logs.add('1완료')),
      ],
      children: [
        GaplyMotion(
          animations: [
            ShakeStyle(
              duration: const Duration(milliseconds: 200),
            ).copyWith(onComplete: () => logs.add('2완료')),
          ],
        ),
      ],
      onComplete: () => logs.add('최종완료'),
    );

    // 2. 실제 위젯 트리 빌드 (myApp 대신 직접 작성)
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: complexAnim.buildWidget(
            child: const Text('Target'),
            trigger: 'start', // 초기 트리거
          ),
        ),
      ),
    );

    // 1. PostFrameCallback 실행 (execute 호출)
    await tester.pump();

    // 2. Shake 1번 시작을 위해 아주 짧은 시간 프레임 진행
    await tester.pump(const Duration(milliseconds: 300));

    // 3. Shake 1번이 끝날 때까지 (200ms + 여유분)
    await tester.pump(const Duration(milliseconds: 300));
    print('1번 종료 후 로그: $logs');

    // 4. Shake 2번 시작 및 종료 대기 (200ms + 여유분)
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle(); // 남은 잔여 프레임 정리

    print('최종 로그: $logs');

    expect(logs, contains('1완료'));
    expect(logs, contains('2완료'));
    expect(logs, contains('최종완료'));
  });
}

// void main() {
//   testWidgets('Gaply 시퀀스 애니메이션 콜백 순서 및 완료 테스트', (WidgetTester tester) async {
//     List<String> logs = [];
//
//     final complexAnim = GaplyMotion(
//       styles: [
//         ShakeStyle(duration: const Duration(milliseconds: 200)).copyWith(onComplete: () => logs.add('1완료')),
//       ],
//       children: [
//         GaplyMotion(
//           styles: [
//             ShakeStyle(
//               duration: const Duration(milliseconds: 200),
//             ).copyWith(onComplete: () => logs.add('2완료')),
//           ],
//         ),
//       ],
//       onComplete: () => logs.add('최종완료'),
//     );
//
//     // 2. 실제 위젯 트리 빌드 (myApp 대신 직접 작성)
//     await tester.pumpWidget(
//       Directionality(
//         textDirection: TextDirection.ltr,
//         child: Center(
//           child: complexAnim.buildWidget(
//             child: const Text('Target'),
//             trigger: 'start', // 초기 트리거
//           ),
//         ),
//       ),
//     );
//
//     // 1. PostFrameCallback 실행 (execute 호출)
//     await tester.pump();
//
//     // 2. Shake 1번 시작을 위해 아주 짧은 시간 프레임 진행
//     await tester.pump(const Duration(milliseconds: 300));
//
//     // 3. Shake 1번이 끝날 때까지 (200ms + 여유분)
//     await tester.pump(const Duration(milliseconds: 300));
//     print('1번 종료 후 로그: $logs');
//
//     // 4. Shake 2번 시작 및 종료 대기 (200ms + 여유분)
//     await tester.pump(const Duration(milliseconds: 300));
//     await tester.pumpAndSettle(); // 남은 잔여 프레임 정리
//
//     print('최종 로그: $logs');
//
//     expect(logs, contains('1완료'));
//     expect(logs, contains('2완료'));
//     expect(logs, contains('최종완료'));
//   });
// }
