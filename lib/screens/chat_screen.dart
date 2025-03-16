import 'dart:async';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import '../models/message.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _showHistory = false;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _listenToMessages();
  }

  void _listenToMessages() {
    final user = _authService.getCurrentUser();
    if (user == null) return;

    _chatService.getMessages(user.uid).listen((snapshot) {
      setState(() {
        _messages = snapshot.docs
            .map((doc) => Message.fromFirestore(doc))
            .toList();
      });
      _startTimers();
    });
  }

  void _startTimers() {
    for (var message in List.from(_messages)) {
      if (message.senderId == _authService.getCurrentUser()?.uid) {
        Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() => _messages.removeWhere((msg) => msg.id == message.id));
          }
        });
      } else {
        Timer(const Duration(minutes: 1), () {
          if (mounted) {
            setState(() => _messages.removeWhere((msg) => msg.id == message.id));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShadowChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _tapCount++;
            if (_tapCount == 3) {
              _showHistory = !_showHistory;
              _tapCount = 0;
            }
          });
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return ListTile(
                    title: Text(_chatService.decryptMessage(msg.encryptedText, msg.iv)),
                  );
                },
              ),
            ),
            if (_showHistory)
              Container(
                color: Colors.grey[800],
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Chat History (Placeholder)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _chatService.sendMessage(
                          'receiverId', // Replace with real receiver ID
                          _messageController.text,
                        );
                        _messageController.clear();
                        setState(() => _showHistory = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
