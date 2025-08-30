import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/btmSheet.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/features/Settings/Widget/ProfileCard/editBio.dart';
import '../../../../Firebase/FirebaseCollections.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/TextField.dart';
import '../../../../core/icons.dart';
import 'ImageFullScreen.dart';
import 'LinkScreen.dart';
import 'editName.dart';
import 'imageSheet.dart';
import 'imageWidget.dart';

class nameCard extends StatefulWidget {
  const nameCard({
    super.key,
    required this.userName, this.link, this.bio,
  });

  final dynamic userName;
  final dynamic link;
  final dynamic bio;
  @override
  State<nameCard> createState() => _nameCardState();
}

class _nameCardState extends State<nameCard> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userName;
    linkController.text = widget.link;
    bioController.text = widget.bio;

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
    FirebaseService service = FirebaseService();
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
                  final bio = data.data().toString().contains("bio") ? data["bio"] : "";
                  final name = data.data().toString().contains("name") ? data["name"] : "";
                  final link = data.data().toString().contains("link") ? data["link"] : "";

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (imageUrl != null && imageUrl.isNotEmpty) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImageScreen(imageUrl: imageUrl),
                                    ),
                                  );
                          } else {
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
                        child: Column(
                          children: [
                            Options(
                              context: context,
                              trailing: icons.arrowForward,
                              label: Text(name.isNotEmpty ? name : "Edit Your Name"),
                              onTap: () async {
                                await btmSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return editName(
                                      service: service,
                                      nameController: nameController,
                                      name: name
                                    );
                                  },
                                );
                              },
                            ),
                            divider(),
                            Options(
                              context: context,
                              trailing: icons.arrowForward,
                              label: Text(bio.isNotEmpty ? bio : "Edit Your Bio"),
                              onTap: () async {
                                await btmSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Editbio(
                                        bio: bio,
                                        bioController: bioController,
                                        service: service);
                                  }
                                );
                              },
                            ),
                            divider(),
                            Options(
                              context: context,
                              trailing: icons.instagram,
                              label: Text("Link"),
                              onTap: () async {
                                await btmSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return LinksScreen(
                                        linkController: linkController,
                                        link: link);
                                  },
                                );

                                // await ShowSheet(context);
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


