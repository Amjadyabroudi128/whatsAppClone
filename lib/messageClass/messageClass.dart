import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String text;
  final String? receiverId;
  final String? senderEmail;
  final String? senderId;
  final String? receiverEmail;
  final Timestamp? time;
  final String? messageId;
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
      isStarred: map['isStarred'],
      isReply: map['isReply'] ?? false,
      replyTo: map['replyTo'] != null
          ? Messages.fromMap(Map<String, dynamic>.from(map['replyTo']))
          : null,
      isEdited: map['isEdited'] ?? false,
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
      'isEdited': isEdited,
    };
  }

  // copyWith method to immutably update fields
  Messages copyWith({
    String? text,
    String? receiverId,
    String? senderEmail,
    String? senderId,
    String? receiverEmail,
    Timestamp? time,
    String? messageId,
    String? image,
    String? file,
    bool? isStarred,
    bool? isReply,
    Messages? replyTo,
    bool? isEdited,
  }) {
    return Messages(
      text: text ?? this.text,
      receiverId: receiverId ?? this.receiverId,
      senderEmail: senderEmail ?? this.senderEmail,
      senderId: senderId ?? this.senderId,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      time: time ?? this.time,
      messageId: messageId ?? this.messageId,
      image: image ?? this.image,
      file: file ?? this.file,
      isStarred: isStarred ?? this.isStarred,
      isReply: isReply ?? this.isReply,
      replyTo: replyTo ?? this.replyTo,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
