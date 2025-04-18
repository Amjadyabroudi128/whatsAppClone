import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/dividerWidget.dart';
import 'package:whatsappclone/features/Settings/Widget/showSheet.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/icons.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;
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
    loadBio();
  }

  void loadBio() async {
    String? fetchedBio = await FirebaseService().getBio();
    setState(() {
      userBio = fetchedBio ?? "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(children: [
            Card(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child:Image.network(
                "https://media.licdn.com/dms/image/v2/C5603AQGWALNlfWBXcA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1634729409931?e=1749686400&v=beta&t=uE3GxROfoynmR_1PjjxcMbumU-JgwfruBzZBTlrDkPA",
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Positioned(
              bottom: 0,
              right: -17,
              child: kIconButton(
                myIcon: icons.camera,
                onPressed: () async {
                  await url.pickImage();
                  addtoFireStore();
                },
              ),
            )
          ]),
          BoxSpacing(
            myHeight: 5,
          ),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  addtoFireStore() {
    FirebaseFirestore.instance.collection("users").doc().set({
      "image": url.url
    });
  }
}
