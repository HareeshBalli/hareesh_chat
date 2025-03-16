import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart'; // Keep for mocking
import 'package:mockito/mockito.dart';
import 'package:hareesh_chat/main.dart'; // Corrected package name

// Mock class for Firebase
class MockFirebaseCore extends Mock implements FirebaseApp {}

void main() {
  setupAll(() {
    // Mock Firebase initialization
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('ShadowChat displays AuthScreen', (WidgetTester tester) async {
    // Mock FirebaseApp instance
    final mockApp = MockFirebaseCore();

    // Wrap the app with a mock environment
    await tester.pumpWidget(
      MaterialApp(
        home: ShadowChatApp(),
      ),
    );

    // Verify that AuthScreen is displayed (adjust based on your AuthScreen widget)
    expect(find.text('Login'), findsOneWidget); // Adjust 'Login' to match your AuthScreen's AppBar title
  });
}