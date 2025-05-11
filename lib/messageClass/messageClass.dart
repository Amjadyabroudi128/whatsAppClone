import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String text;
  final String? receiverId;
  final String? senderEmail;
  final String? senderId;
  final String? receiverEmail;
  final Timestamp? time;
  final String? messageId; // Add this
  final String? image;
  final String? file;
  final bool? isStarred;
  Messages({
    required this.text,
    this.receiverEmail,
    this.senderId,
    this.receiverId,
    this.senderEmail,
    this.time,
    this.messageId,
    this.image,
    this.file,
    this.isStarred
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "message": text,
      "receiverId": receiverId,
      "receiverEmail": receiverEmail,
      "senderEmail": senderEmail,
      "time": time,
      "image": image,
      "file": file,
      "isStarred": isStarred
    };
  }
}
