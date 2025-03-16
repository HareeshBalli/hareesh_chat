import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String encryptedText;
  final String iv;
  final DateTime? timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.encryptedText,
    required this.iv,
    this.timestamp,
  });

  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      encryptedText: data['message'],
      iv: data['iv'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}