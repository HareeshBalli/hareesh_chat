import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; // Relative import to match your project structure

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('ShadowChat displays AuthScreen', (WidgetTester tester) async {
    // Pump the app widget
    await tester.pumpWidget(
      const MaterialApp(
        home: ShadowChatApp(),
      ),
    );

    // Verify that AuthScreen is displayed
    expect(find.text('Login'), findsOneWidget); // Matches the AppBar title in AuthScreen
  });
}