import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/Media.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/StarredMessages.dart';

import '../../../core/MyColors.dart';
import '../../../core/icons.dart';

class userDetails extends StatefulWidget {
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? bio;
  final String? receiverId;
  final String? link;
  const userDetails({super.key, this.name, this.email, this.imageUrl, this.bio, this.receiverId, this.link});

  @override
  State<userDetails> createState() => _userDetailsState();
}

class _userDetailsState extends State<userDetails> {
  String getChatRoomId(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort();
    return ids.join("_");
  }
  User? user = FirebaseAuth.instance.currentUser;

  @override
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    String chatRoomId = getChatRoomId(user!.uid, widget.receiverId!);

    return Scaffold(
      backgroundColor: myColors.BG,
      appBar: AppBar(
        backgroundColor: myColors.BG,
        title: Text("Contact Details"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.imageUrl == null || widget.imageUrl!.isEmpty
                  ? kimageNet(
                src: "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
              )
                  : kCard(
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: kimageNet(src: widget.imageUrl!),
              ),
              BoxSpacing(myHeight: 9),
              Text(widget.name ?? '', style: Textstyles.recieverName),
              GestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse(
                      '${widget.link}'));
                },
                child: Text(widget.link ?? "", style: TextStyle(fontSize: 18, decoration: TextDecoration.underline ),),
              ),
              // Text(widget.link ?? "",),
              BoxSpacing(myHeight: 7),
              Text(widget.email ?? '', style: Textstyles.recieverEmail),
              if (widget.bio != null && widget.bio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: kCard(
                    color: myColors.FG,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.bio!, style: Textstyles.bioStyle),
                    ),
                  ),
                ),
              BoxSpacing(myHeight: 5),

              // Starred Messages
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat_rooms")
                    .doc(chatRoomId)
                    .collection("messages")
                    .where("isStarred", isEqualTo: true)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return kCard(
                    color: myColors.familyText,
                    child: Options(
                      context: context,
                      leading: icons.star,
                      label: Row(
                        children: [
                          Text("Starred messages"),
                          Spacer(),
                          if (count > 0) Text(count.toString()),
                        ],
                      ),
                      trailing: icons.arrowForward,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Starredmessages(receiverId: widget.receiverId),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Media
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("chat_rooms").doc(chatRoomId).collection("messages")
                    .where("image", isNotEqualTo: null).orderBy("timestamp", descending: true).snapshots(),
                builder: (context, snapshot) {
                  return kCard(
                    color: myColors.familyText,
                    child: Options(
                      context: context,
                      leading: icons.image,
                      label: Row(
                        children: [
                          Text("Media"),
                          Spacer(),
                        ],
                      ),
                      trailing: icons.arrowForward,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyMedia(receiverId: widget.receiverId),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
