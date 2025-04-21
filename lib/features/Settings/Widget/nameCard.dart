import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/dividerWidget.dart';
import 'package:whatsappclone/features/Settings/Widget/showSheet.dart';
import '../../../Firebase/FirebaseCollections.dart';
import '../../../core/icons.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;

import 'ImageFullScreen.dart';
import 'imageWidget.dart';

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
  final User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadBio();
    loadImage();
  }

  void loadBio() async {
    String? fetchedBio = await FirebaseService().getBio();
    setState(() {
      userBio = fetchedBio ?? "";
    });
  }

  void loadImage() async {
    DocumentSnapshot userDoc = await userC.doc(user!.uid).get();
    final data = userDoc.data() as Map<String, dynamic>?;

    setState(() {
      imageUrl = data != null && data.containsKey("image") ? data["image"] : "";
    });
  }
  void addToFireStore(String imagePath) async {
    await userC.doc(user!.uid).set({
      "image": imagePath,
    }, SetOptions(merge: true));
    setState(() {
      imageUrl = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: userC.doc(user!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.error),
                    );
                  }
                  final data = snapshot.data!;
                  final Map<String, dynamic> userData = data.data() as Map<String, dynamic>;
                  final imageUrl = userData["image"] ?? "";
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImageScreen(imageUrl: imageUrl),
                        ),
                      );
                    },
                    child: Card(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: imageWidget(imageUrl: imageUrl),
                    ),
                  );
                },
              ),
              // Positioned(
              //   bottom: 0,
              //   right: -5,
              //   child: kIconButton(
              //     myIcon: icons.camera,
              //     onPressed: () async {
              //       await url.pickImage();
              //       if (url.url != null && url.url!.isNotEmpty) {
              //         addToFireStore(url.url!);
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
          BoxSpacing(myHeight: 5),
          Card(
            color: myColors.CardColor,
            child: Column(
              children: [
                kListTile(
                  title: Text(widget.userName),
                ),
                divider(),
                GestureDetector(
                  onTap: () async {
                    await ShowSheet(context);
                    loadBio();
                  },
                  child: kListTile(
                    title: Text(
                      userBio.isNotEmpty ? userBio : "Edit Your Bio",
                      style: Textstyles.bioStyle,
                    ),
                    trailing: icons.arrowForward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

