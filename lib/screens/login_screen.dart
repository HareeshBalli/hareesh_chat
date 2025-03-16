import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShadowChat Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final signedIn = await _authService.signIn(
                  _emailController.text,
                  _passwordController.text,
                );
                if (!mounted) return; // Check mounted before using context
                if (signedIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  );
                } else {
                  try {
                    await _authService.signUp(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (!mounted) return; // Check mounted before using context
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    );
                  } catch (e) {
                    if (!mounted) return; // Check mounted before using context
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Sign In / Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}