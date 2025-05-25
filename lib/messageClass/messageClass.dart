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
  final bool? isReply;
  final Messages? replyTo;
  final bool? isEdited;
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
    this.isStarred,
    this.isReply = false,
    this.replyTo,
    this.isEdited,
  });
  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      text: map['message'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      senderEmail: map['senderEmail'],
      receiverEmail: map['receiverEmail'],
      time: map['timestamp'],
      image: map['image'],
      file: map['file'],
      messageId: map['messageId'],
      isReply: map['isReply'] ?? false,
      replyTo: map['replyTo'] != null ? Messages.fromMap(Map<String, dynamic>.from(map['replyTo'])) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'message': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'time': time,
      'image': image,
      'file': file,
      'isStarred': isStarred,
      'isReply': isReply,
      'replyTo': replyTo?.toMap(),
      "isEdited": isEdited
    };
  }
}
