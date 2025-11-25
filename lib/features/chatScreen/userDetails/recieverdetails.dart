import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/Media.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/StarredMessages.dart';
import 'package:whatsappclone/features/contacts/Model/UserModel.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/MyColors.dart';
import '../../../core/appTheme.dart';
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
  bool _showCopyLabel = false;
  late UserModel myBio;
  late UserModel myImage;
  static const String _placeholderImageUrl =
      "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg";

  @override
  void initState() {
    super.initState();
    myBio = UserModel(bio: widget.bio);
    myImage = UserModel(image: widget.imageUrl);
  }

  Future _onTapBio() async {
    if (myBio.bio == null || myBio.bio!.isEmpty) return;

    Clipboard.setData(ClipboardData(text: myBio.bio!));
    setState(() => _showCopyLabel = true);
  }

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (user == null || widget.receiverId == null) {
      return Scaffold(
        backgroundColor: MyColors.bg,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: MyColors.bg,
          title: const Text("Contact Details", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("User or receiver information is missing"),
        ),
      );
    }

    String chatRoomId = getChatRoomId(user!.uid, widget.receiverId!);
    final FirebaseService service = FirebaseService();

    return GestureDetector(
      onTap: () {
        setState(() {
          _showCopyLabel = false;
        });
      },
      child: Scaffold(
        backgroundColor: MyColors.bg,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: MyColors.bg,
          title: const Text("Contact Details", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: service.presenceStream(widget.receiverId!),
                  builder: (context, snap) {
                    final String? url = myImage.image;
                    if (!snap.hasData || snap.data == null || snap.data!.data() == null) {
                      return kCard(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: kimageNet(
                          src: (url != null && url.isNotEmpty)
                              ? url
                              : _placeholderImageUrl,
                        ),
                      );
                    }

                    final data = snap.data!.data() as Map<String, dynamic>;
                    final visibility =
                        data['imageVisibility'] as String? ?? 'Everyone';

                    // If user set visibility to Nobody → show static placeholder
                    if (visibility == 'Nobody') {
                      return const kCard(
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: kimageNet(src: _placeholderImageUrl),
                      );
                    }

                    // If no image URL → show static placeholder
                    if (url == null || url.isEmpty) {
                      return const kCard(
                        shape: CircleBorder(),
                        clipBehavior: .antiAlias,
                        child: kimageNet(src: _placeholderImageUrl),
                      );
                    }

                    return kCard(
                      shape: const CircleBorder(),
                      clipBehavior: .antiAlias,
                      child: kimageNet(src: url),
                    );
                  },
                ),
                const BoxSpacing(myHeight: 9),
                const BoxSpacing(myHeight: 9),
                Text(widget.name ?? '', style: Textstyles.recieverName),

                if (widget.link != null && widget.link!.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(widget.link!));
                    },
                    child: Text(
                      widget.link!,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: .underline,
                        color: MyColors.link
                      ),
                    ),
                  ),
                const BoxSpacing(myHeight: 7),
                Text(widget.email ?? '', style: Textstyles.recieverEmail),

                if (myBio.bio != null && myBio.bio!.isNotEmpty)
                  StreamBuilder(
                    stream: service.presenceStream(widget.receiverId!),
                    builder: (context, snap) {
                      if (!snap.hasData || snap.data == null) {
                        return const SizedBox.shrink();
                      }
                      final data = snap.data!.data();
                      if (data == null) return const SizedBox.shrink();

                      final visibility = data['BioVisibility'] as String? ?? 'Everyone';
                      if (visibility == 'Nobody') {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onLongPress: _onTapBio,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: kCard(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(myBio.bio ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                if (_showCopyLabel)
                  Padding(
                    padding: const EdgeInsets.only(left: 260),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: MyTheme.appTheme == true ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: kTextButton(
                        onPressed: () async {
                          await _onTapBio();
                          setState(() {
                            _showCopyLabel = false;
                            myToast("Bio Copied");
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            icons.copy(context),
                            const BoxSpacing(mWidth: 10),
                            Text(
                              "Copy",
                              style: TextStyle(
                                color: MyTheme.appTheme == true ? Colors.white : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                const BoxSpacing(myHeight: 5),

                // Starred Messages
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("starred-messages")
                      .doc(auth.currentUser!.email!)
                      .collection("messages")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int count = 0;
                    if (snapshot.hasData && snapshot.data != null) {
                      final currentChatMessages = snapshot.data!.docs.where((doc) {
                        final data = doc.data();
                        List<String> ids = [data['senderId'], data['receiverId']];
                        ids.sort();
                        String docChatRoomID = ids.join("_");
                        return docChatRoomID == chatRoomId;
                      }).toList();
                      count = currentChatMessages.length;
                    }
                    return kCard(
                      color: MyColors.familyText,
                      child: Options(
                        context: context,
                        leading: icons.star(context),
                        label: Row(
                          children: [
                            const Text("Starred messages"),
                            const Spacer(),
                            if (count > 0) Text(count.toString()),
                          ],
                        ),
                        trailing: icons.arrowForward(context),
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
                  stream: FirebaseFirestore.instance
                      .collection("chat_rooms")
                      .doc(chatRoomId)
                      .collection("messages")
                      .where("image", isNotEqualTo: null)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return kCard(
                      color: MyColors.familyText,
                      child: Options(
                        context: context,
                        leading: icons.image(context),
                        label: const Row(
                          children: [
                            Text("Media"),
                            Spacer(),
                          ],
                        ),
                        trailing: icons.arrowForward(context),
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
      ),
    );
  }
}