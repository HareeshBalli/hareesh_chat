import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hareesh_chat/main.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('ShadowChat displays AuthScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShadowChatApp(),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });
}