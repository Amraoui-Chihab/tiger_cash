import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String? senderId;
  String senderName;
  String senderImageUrl;
  String text;
  DateTime timestamp;

  Message(
      {required this.id,
      required this.senderName,
      required this.senderImageUrl,
      required this.text,
      required this.timestamp,
      this.senderId});

  factory Message.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Message(
      id: doc.id,
      senderName: doc['senderName'],
      senderImageUrl: doc['senderImageUrl'],
      text: doc['text'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      senderId: doc["id"],
    );
  }
}
