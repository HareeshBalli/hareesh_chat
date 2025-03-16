import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id; // Unique identifier
  final String senderId;
  final String receiverId;
  final String encryptedText;
  final String iv;
  final DateTime? timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.encryptedText,
    required this.iv,
    this.timestamp,
  });

  // Factory constructor to create a Message from Firestore data
  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id, // Assign document ID
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      encryptedText: data['message'] ?? '',
      iv: data['iv'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  // Convert Message to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': encryptedText,
      'iv': iv,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}
