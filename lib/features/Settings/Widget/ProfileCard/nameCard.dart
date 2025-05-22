import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/features/Settings/Widget/ProfileCard/showSheet.dart';
import '../../../../Firebase/FirebaseCollections.dart';
import '../../../../core/icons.dart';
import 'ImageFullScreen.dart';
import 'imageSheet.dart';
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
  final User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
  }

  Future addToFireStore(String imagePath) async {
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
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text("No user data available"));
                  }
                  final data = snapshot.data!;
                  final imageUrl = data.data().toString().contains("image") ? data["image"] : "";
                  final bio = data["bio"] ?? "";
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (imageUrl != null && imageUrl.isNotEmpty)
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImageScreen(imageUrl: imageUrl),
                                    ),
                                  );
                          else {
                            await showImage(
                              context,
                              addToFirebase: (String path) async {
                                await addToFireStore(path);
                              },
                            );
                          }

                        },
                        child: kCard(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: imageWidget(imageUrl: imageUrl),
                        ),
                      ),
                      BoxSpacing(myHeight: 5),
                      kCard(
                        color: myColors.CardColor,
                        child: Column(
                          children: [
                            kListTile(
                              title: Text(widget.userName),
                            ),
                            divider(),
                            Options(
                              context: context,
                              trailing: icons.arrowForward,
                              label: Text(bio.isNotEmpty ? bio : "Edit Your Bio"),
                              onTap: () async {
                                await ShowSheet(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
