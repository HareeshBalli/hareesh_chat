import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ShadowChatApp());
}

class ShadowChatApp extends StatelessWidget {
  const ShadowChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowChat',
      theme: ThemeData.dark(),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;

  Future<void> _verifyPhone() async {
    print('Verifying: ${_phoneController.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      },
      verificationFailed: (e) => print('Failed: ${e.message}'),
      codeSent: (verificationId, _) => setState(() => _verificationId = verificationId),
      codeAutoRetrievalTimeout: (verificationId) => setState(() => _verificationId = verificationId),
    );
  }

  Future<void> _signInWithCode() async {
    if (_verificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: '+919876543210'),
            ),
            ElevatedButton(
              onPressed: _verifyPhone,
              child: const Text('Send OTP'),
            ),
            if (_verificationId != null) ...[
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(hintText: 'Enter OTP'),
              ),
              ElevatedButton(
                onPressed: _signInWithCode,
                child: const Text('Verify'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}