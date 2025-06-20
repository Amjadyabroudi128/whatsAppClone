import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/features/contacts/Widgets/userListTile.dart';

import '../../../Firebase/FirebaseCollections.dart';
import '../../../components/SizedBox.dart';
import '../../../components/listTilesOptions.dart';
import '../../../components/padding.dart';
import '../../../core/icons.dart';
import '../../chatScreen/chatScreen.dart';

Widget userList(String searchQuery,) {
  User? user = FirebaseAuth.instance.currentUser;
  final currentUserId = user?.uid ?? '';

  if (searchQuery.trim().isEmpty) {
    return const Flexible(
      child: Center(
        child: Text(
          "Search for users\n to start a chat with them",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  return Flexible(
    child: StreamBuilder<QuerySnapshot>(
      stream: userC.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No users found"));
        }

        // Filter out current user and apply search
        final users = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name']?.toLowerCase() ?? '';
          return doc.id != currentUserId &&
              name.contains(searchQuery.toLowerCase());
        }).toList();

        if (users.isEmpty) {
          return Center(child: Text("No users match your search"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final image = userDoc['image'];
            return myPadding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Options(
                    context: context,
                    label: Text(userDoc["name"]),
                    leading: image != null && image.isNotEmpty ? CircleAvatar(
                      backgroundImage: NetworkImage(image),
                      radius: 20,
                    ) : icons.person,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Testname(
                            receiverId: userDoc["uid"],
                            receiverName: userDoc["name"] ?? "Unknown",
                          ),
                        ),
                      );
                    }
                  ),
                   Divider(),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
