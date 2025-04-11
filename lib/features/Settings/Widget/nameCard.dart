import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/editBio.dart';

import '../../../core/icons.dart';

class nameCard extends StatefulWidget {
  const nameCard({
    super.key,
    required this.userName,
  });

  final dynamic userName;

  @override
  State<nameCard> createState() => _nameCardState();
}

class _nameCardState extends State<nameCard> {
  String userBio = "";

  @override
  void initState() {
    super.initState();
    _loadUserBio();
  }

  Future<void> _loadUserBio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      setState(() {
        userBio = doc.data()?["bio"] ?? "No bio yet";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Image.network(
              "https://media.licdn.com/dms/image/v2/C5603AQGWALNlfWBXcA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1634729409931?e=1749686400&v=beta&t=uE3GxROfoynmR_1PjjxcMbumU-JgwfruBzZBTlrDkPA",
              fit: BoxFit.cover,
              height: 200,
            ),
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
          ),
          Card(
            color: myColors.CardColor,
            child: ListTile(
              title: Text(widget.userName),
              subtitle: ListTile(
                title: Text(userBio),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditBio()),
                    ).then((_) => _loadUserBio()); // reload after editing
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
