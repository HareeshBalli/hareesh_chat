import 'dart:async';
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import '../models/message.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    _chatService.getMessages(_authService.getCurrentUser()!.uid).listen((snapshot) {
      setState(() {
        _messages = snapshot.docs
            .map((doc) => Message.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();
      });
      _startTimers();
    });
  }

  void _startTimers() {
    for (var message in List.from(_messages)) {
      if (message.senderId == _authService.getCurrentUser()!.uid) {
        Timer(Duration(seconds: 5), () {
          if (mounted) {
            setState(() => _messages.remove(message));
          }
        });
      } else {
        Timer(Duration(minutes: 1), () {
          if (mounted) {
            setState(() => _messages.remove(message));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShadowChat'),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
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
                padding: EdgeInsets.all(8.0),
                child: Text('Chat History (Placeholder)', style: TextStyle(color: Colors.white)),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
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