import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseCollections.dart';

 ProfileStream() {
  User? user = FirebaseAuth.instance.currentUser;
  return StreamBuilder(
    stream: userC
        .doc(user!.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
        );
      }

      final data = snapshot.data!.data() as Map<String, dynamic>;
      final imageUrl = data["image"] ?? "";

      return Container(
        width: 60,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  );
}