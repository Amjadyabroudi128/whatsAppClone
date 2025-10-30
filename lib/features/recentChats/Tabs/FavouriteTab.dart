import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
class FavouriteTab extends StatefulWidget {
  const FavouriteTab({super.key});

  @override
  State<FavouriteTab> createState() => _FavouriteTabState();
}

class _FavouriteTabState extends State<FavouriteTab> {
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  String getChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join("_");
  }
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Favourite"));
  }
}
