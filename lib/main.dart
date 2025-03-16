import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDISYtshenfaToF-d1cVyJiYEG4o5lBlQI",
      authDomain: "shadowchat-73d0b.firebaseapp.com",
      projectId: "shadowchat-73d0b",
      storageBucket: "shadowchat-73d0b.firebasestorage.app",
      messagingSenderId: "505358154982",
      appId: "1:505358154982:web:c2f7309211612923fd8f27",
    ),
  );
  runApp(ShadowChatApp());
}

class ShadowChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowChat',
      theme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}