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
  final String? reactBy;
  final String? reactionEmoji;
  final bool? isViewed;
  final bool? isViewOnce;

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
    this.reactBy,
    this.reactionEmoji,
    this.isViewed,
    this.isViewOnce = false,
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
      isStarred: map['isStarred'] ?? false,
      isReply: map['isReply'] ?? false,
      replyTo: map['replyTo'] != null
          ? Messages.fromMap(Map<String, dynamic>.from(map['replyTo']))
          : null,
      isEdited: map['isEdited'] ?? false,
      scheduledFor: map['scheduledFor'],
      isScheduled: map['isScheduled'] ?? false,
      isReacted: map["isReacted"] ?? false,
      reactBy: map["reactBy"],
      reactionEmoji: map["reactionEmoji"],
      isViewed: map["isViewed"],
      isViewOnce: map['isViewOnce'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "isRead": isRead ?? false,
      "senderName": senderName,
      'messageId': messageId,
      'message': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'timestamp': time,
      'image': image ?? '',
      'file': file ?? '',
      'isStarred': isStarred ?? false,
      'isReply': isReply ?? false,
      'replyTo': replyTo?.toMap(),
      'isEdited': isEdited ?? false,
      'scheduledFor': scheduledFor,
      'isScheduled': isScheduled ?? false,
      "isReacted": isReacted ?? false,
      "reactBy": reactBy,
      "reactionEmoji": reactionEmoji,
      "isViewed": isViewed ?? false,
      'isViewOnce': isViewOnce ?? false,
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
    String? reactBy,
    String? reactionEmoji,
    bool? isViewed,
    bool? isViewOnce,
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
      reactBy: reactBy ?? this.reactBy,
      reactionEmoji: reactionEmoji ?? this.reactionEmoji,
        isViewed: isViewed ?? this.isViewed,
      isViewOnce: isViewOnce ?? this.isViewOnce,
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
      receiverEmail: data['receiverEmail'],
      image: data['image'] ?? '',
      file: data['file'] ?? '',
      time: data['timestamp'],
      isStarred: data['isStarred'] ?? false,
      isReply: data['isReply'] ?? false,
      replyTo: data['replyTo'] != null
          ? Messages.fromMap(Map<String, dynamic>.from(data['replyTo']))
          : null,
      isEdited: data['isEdited'] ?? false,
      scheduledFor: data['scheduledFor'],
      isScheduled: data['isScheduled'] ?? false,
      isReacted: data["isReacted"] ?? false,
      reactBy: data["reactBy"],
      reactionEmoji: data["reactionEmoji"],
        isViewed: data["isViewed"] ?? false,
      isViewOnce: data['isViewOnce'] ?? false,
    );
  }
}