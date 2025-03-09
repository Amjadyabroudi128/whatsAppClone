import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../privateChatScreen/chatScreen.dart';
import '../testingScreen/Widgets/signoutBtn.dart';

class Mainchat extends StatelessWidget {
  final String? name;
  const Mainchat({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No other users found'));
          }

          // Get user docs excluding current user
          final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

          if (users.isEmpty) {
            return Center(child: Text('No other users found'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userEmail = user['email'];
              final isOnline = user['isOnline'];

              return ListTile(
                title: Text(userEmail),
                subtitle: Text(isOnline ? 'Online' : 'Offline'),
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'privateChatScreen', arguments: {
                    'receiverId': user['uid'],
                    'receiverEmail': userEmail,
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
