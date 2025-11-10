import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? bio;
  final String name;
  final bool isOnline;
  final String email;
  final String? link;
  final String onlineVisibility;
  final String uid;
  final String? image;
  final String fcmToken;
  final Timestamp? createdAt;
  final Timestamp? lastSeen;

  User({
    required this.name,
    required this.isOnline,
    required this.email,
     this.link,
    required this.onlineVisibility,
    required this.uid,
    this.image,
    required this.fcmToken,
    this.bio,
    this.createdAt,
    this.lastSeen,
  });

  // Convert User object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'name': name,
      'isOnline': isOnline,
      'email': email,
      'link': link,
      'onlineVisibility': onlineVisibility,
      'uid': uid,
      'image': image,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'lastSeen': lastSeen,
    };
  }

  // Convert Map from Firebase to User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      bio: map['bio'],
      name: map['name'],
      isOnline: map['isOnline'] ?? false,
      email: map['email'],
      link: map['link'],
      onlineVisibility: map['onlineVisibility'],
      uid: map['uid'],
      image: map['image'],
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'],
      lastSeen: map['lastSeen'],
    );
  }

  // Convert DocumentSnapshot to User object
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      bio: data['bio'],
      name: data['name'],
      isOnline: data['isOnline'] ?? false,
      email: data['email'],
      link: data['link'],
      onlineVisibility: data['onlineVisibility'],
      uid: data['uid'],
      image: data['image'],
      fcmToken: data['fcmToken'],
      createdAt: data['createdAt'],
      lastSeen: data['lastSeen'],
    );
  }

  // Create a copy of User with optional field updates
  User copyWith({
    String? bio,
    String? name,
    bool? isOnline,
    String? email,
    String? link,
    String? onlineVisibility,
    String? uid,
    String? image,
    String? fcmToken,
    Timestamp? createdAt,
    Timestamp? lastSeen,
  }) {
    return User(
      bio: bio ?? this.bio,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
      email: email ?? this.email,
      link: link ?? this.link,
      onlineVisibility: onlineVisibility ?? this.onlineVisibility,
      uid: uid ?? this.uid,
      image: image ?? this.image,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}