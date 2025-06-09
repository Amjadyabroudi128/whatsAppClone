import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/features/contacts/Widgets/userListTile.dart';

import '../../../Firebase/FirebaseCollections.dart';
import '../../../components/SizedBox.dart';
import '../../../components/padding.dart';
import 'iconPerson.dart';

Widget userList(String searchQuery) {
  User? user = FirebaseAuth.instance.currentUser;
  final currentUserId = user?.uid ?? '';

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
            return myPadding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      person(),
                      BoxSpacing(mWidth: 10),
                      Expanded(
                        child: listTile(userDoc: userDoc),
                      ),
                    ],
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
