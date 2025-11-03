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
  final String? senderName;
  final bool? isRead;
  final Timestamp? scheduledFor;
  final bool? isScheduled;
  final bool? isReacted;
  final Messages? reactBy;
  Messages({
    required this.text,
    this.senderName,
    this.isRead,
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
    this.scheduledFor,
    this.isScheduled = false,
    this.isReacted = false,
    this.reactBy
  });

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      isRead: map["isRead"] ?? false,
      text: map['message'],
      senderName: map["senderName"],
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
      scheduledFor: map['scheduledFor'],
      isScheduled: map['isScheduled'] ?? false,
      isReacted: map["isReacted"] ?? false,
      reactBy: map['reactBy'] != null
          ? Messages.fromMap(Map<String, dynamic>.from(map['reactBy']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "isRead": isRead,
      "senderName": senderName,
      'messageId': messageId,
      'message': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'time': time,
      'image': image ?? '',
      'file': file ?? '',
      'isStarred': isStarred,
      'isReply': isReply,
      'replyTo': replyTo?.toMap(),
      'isEdited': isEdited,
      'scheduledFor': scheduledFor,
      'isScheduled': isScheduled,
      "isReacted" : isReacted,
      "reactBy": reactBy?.toMap(),
    };
  }

  Messages copyWith({
    bool? isRead,
    String? text,
    String? receiverId,
    String? senderEmail,
    String? senderName,
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
    Timestamp? scheduledFor,
    bool? isScheduled,
    bool? isReacted,
    Messages? reactBy,
  }) {
    return Messages(
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      isRead: isRead ?? this.isRead,
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
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isScheduled: isScheduled ?? this.isScheduled,
      isReacted: isReacted ?? this.isReacted,
      reactBy: reactBy ?? this.reactBy
    );
  }

  factory Messages.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Messages(
      isRead: data['isRead'] ?? false,
      messageId: doc.id,
      senderName: data["senderName"],
      text: data['message'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      senderEmail: data['senderEmail'],
      image: data['image'] ?? '',
      time: data['time']?.toDate(),
      scheduledFor: data['scheduledFor'],
      isScheduled: data['isScheduled'] ?? false,
      isReacted: data["isReacted"] ?? false,
      reactBy: data['reactBy'] != null
          ? Messages.fromMap(Map<String, dynamic>.from(data['reactBy']))
          : null,
    );
  }
}