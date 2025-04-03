import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String text;
  final String? receiverId;
  final String? senderEmail;
  final String? senderId;
  final String? receiverEmail;
  final Timestamp? time;
  final String? messageId; // Add this

  Messages({
    required this.text,
    this.receiverEmail,
    this.senderId,
    this.receiverId,
    this.senderEmail,
    this.time,
    this.messageId, // Include it in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "message": text,
      "receiverId": receiverId,
      "receiverEmail": receiverEmail,
      "senderEmail": senderEmail,
      "time": time,
    };
  }
}
