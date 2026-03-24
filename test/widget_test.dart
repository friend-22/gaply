import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaply/gaply.dart';

void main() {
  testFade();
}

void testFade() {
  testWidgets('Fade animation fades in', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GaplyFade(style: FadeStyle(isVisible: true), child: SizedBox(width: 100, height: 100)),
        ),
      ),
    );

    expect(find.byType(FadeTransition), findsOneWidget);
  });
}
