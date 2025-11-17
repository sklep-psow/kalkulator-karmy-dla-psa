// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator_karmy/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KalkulatorKarmy());

    // Verify that the app title is shown
    expect(find.text('Kalkulator Karmy dla Psa'), findsOneWidget);
  });
}
