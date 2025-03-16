import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final senderId = _auth.currentUser!.uid;

    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(message, iv: iv);

    await _firestore.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': encrypted.base64,
      'iv': iv.base64,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages(String receiverId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String decryptMessage(String encryptedText, String ivText) {
    final key = encrypt.Key.fromLength(32); // Match sender's key in production
    final iv = encrypt.IV.fromBase64(ivText);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}