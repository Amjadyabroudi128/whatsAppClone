import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import '../../../components/TextStyles.dart';
import '../../../components/flutterToast.dart';
import 'package:whatsappclone/features/chatScreen/Widgets/deleteMessage.dart';
import 'package:media_gallery_saver/media_gallery_saver.dart';

import 'Widgets/deleteContainer.dart';

class Imagescreen extends StatefulWidget {
  final String date;
  final String? senderName;
  final String time;
  final String? image;
  final String? messageId;
  final String? receiverId;
  final bool? isStarred;

  const Imagescreen({
    super.key,
    required this.date,
    required this.senderName,
    required this.time,
    this.image,
    this.messageId,
    this.receiverId,
    this.isStarred,
  });

  @override
  State<Imagescreen> createState() => _ImagescreenState();
}

class _ImagescreenState extends State<Imagescreen> {
  final TextStyle dates = TextStyle(fontSize: 13);
  final auth = FirebaseAuth.instance;
  final FirebaseService service = FirebaseService();
  bool _isStarred = false;

  @override
  void initState() {
    super.initState();
    _isStarred = widget.isStarred ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    // Creating a dummy Messages object for deletion
    final Messages msg = Messages(
      messageId: widget.messageId,
      image: widget.image,
      senderEmail: user?.email,
      senderId: user?.uid,
      receiverId: widget.receiverId,
      text: "", // Empty, not needed for image delete
      isStarred: _isStarred
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.senderName == auth.currentUser!.email ? "You" : widget.senderName ?? "",
              style: TextStyle(fontSize: 19),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.date, style: dates),
                BoxSpacing(mWidth: 7),
                Text(widget.time, style: dates)
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Image.network(
            widget.image!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: icons.deleteIcon,
              onPressed: () async {
                await showModalBottomSheet(
                  backgroundColor: myColors.familyText,
                  context: context,
                  builder: (context) =>
                      deleteContainer(service: service, user: user, widget: widget, msg: msg),
                );
              },
            ),
            kIconButton(
              myIcon: _isStarred ? icons.slash : icons.stary,
              onPressed: () async {
                if (_isStarred) {
                  await service.deleteStar(msg);
                  myToast("Message unstarred");
                } else {
                  await service.addToStar(msg);
                  myToast("Message starred");
                }
                setState(() {
                  _isStarred = !_isStarred;
                });
              },
            ),
            kIconButton(
              myIcon: icons.share,
              onPressed: ()  async {
                await MediaGallerySaver().saveMediaFromUrl(url: msg.image!);
                // Add share logic if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}

