import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/fSizedBox.dart';
import 'package:whatsappclone/components/iconButton.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/icons.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import '../../../Firebase/FirebaseCollections.dart';
import '../../../components/dividerContainer.dart';
import '../../../components/flutterToast.dart';
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
  final String? day;
  final String? senderId;
  final String? senderEmail;
  final String? receiverEmail;
  final bool? isMe;
  const Imagescreen({
    super.key,
    required this.date,
    required this.senderName,
    required this.time,
    this.image,
    this.messageId,
    this.receiverId,
    this.isStarred,
    this.day,
    this.senderId,
    this.receiverEmail,
    this.senderEmail,
    this.isMe
  });

  @override
  State<Imagescreen> createState() => _ImagescreenState();
}

class _ImagescreenState extends State<Imagescreen> {
  static const TextStyle dates = TextStyle(fontSize: 13);
  final auth = FirebaseAuth.instance;
  final FirebaseService service = FirebaseService();
  bool _isStarred = false;
  bool _isMe = false;
  @override
  void initState() {
    super.initState();
    _isStarred = widget.isStarred ?? false;
    _isMe = widget.isMe ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
   final msg = Messages(
      text: "",
      senderId: widget.senderId,
      senderName: widget.senderName,
      receiverId: widget.receiverId,
      senderEmail: widget.senderEmail,
      receiverEmail: widget.receiverEmail,
      messageId: widget.messageId,
      image: widget.image,
    );
    Future addToFireStore(String imagePath) async {
      await userC.doc(user!.uid).set({
        "image": imagePath,
      }, SetOptions(merge: true));
      setState(() {
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.senderName == auth.currentUser!.displayName ? "You" : widget.senderName ?? "",
              style: const TextStyle(fontSize: 19),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.date, style: dates),
                const BoxSpacing(mWidth: 7),
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // For light theme
          bottomAppBarTheme: Theme.of(context).brightness == Brightness.light
              ? const BottomAppBarThemeData(
            color: Colors.white,
            shadowColor: Colors.grey,
            elevation: 8,
          )
          // For dark theme
              : BottomAppBarThemeData(
            color: MyColors.darkCard, // Use your dark card color
            shadowColor: Colors.black,
            elevation: 8,
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if(_isMe)
              IconButton(
                icon: icons.deleteIcon,
                onPressed: () async {
                  await showModalBottomSheet(
                    backgroundColor: MyColors.familyText,
                    context: context,
                    builder: (context) =>
                        deleteContainer(service: service, user: user, widget: widget, msg: msg),
                  );
                },
              ),
              kIconButton(
                myIcon: _isStarred ? icons.slash(context) : icons.stary,
                onPressed: () async {
                  if (_isStarred) {
                    FocusScope.of(context).unfocus();
                    await service.deleteStar(msg);
                    myToast("Message unstarred");
                  } else {
                    FocusScope.of(context).unfocus();
                    await service.addToStar(msg);
                    myToast("Message starred");
                  }
                  setState(() {
                    _isStarred = !_isStarred;
                  });
                  FocusScope.of(context).unfocus();
                  // Navigator.pop(context);
                },
              ),
              kIconButton(
                myIcon: icons.share(context),
                onPressed: ()async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                     return  Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const DividerContainer(),
                              Row(
                                children: [
                                  Container(
                                    height: 49, width: 49,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(msg.image!),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  const BoxSpacing(mWidth: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user!.email == auth.currentUser!.email ? "You" : user.email}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Row(
                                        children: [
                                          Text(widget.date, style: dates),
                                          BoxSpacing(mWidth: 7,),
                                          Text(widget.time, style: dates)
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  kIconButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    myIcon: icons.close,
                                  )
                                ],
                              ),
                              kCard(
                                // color: Colors.grey,
                                child: Column(
                                  children: [
                                    Options(
                                      context: context,
                                      label: const Text("Set as Profile photo"),
                                      trailing: icons.person,
                                        onTap: () async  {
                                        Navigator.of(context).pop();
                                         await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return fSizedBox(
                                                heightFactor: 0.7,
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 200,
                                                        backgroundImage: NetworkImage(msg.image!),
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          kTextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("Cancel"),
                                                          ),
                                                          const Spacer(),
                                                          kTextButton(
                                                            onPressed: () async {
                                                              await addToFireStore(widget.image!);
                                                              myToast("image is Updated");
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("Choose"),
                                                          ),
                                                        ],
                                                      ),
                                                      // Add more widgets here
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                    ),
                                    const divider(),
                                    Options(
                                        context: context,
                                        label: const Text("Save to Gallery"),
                                        trailing: icons.share(context),
                                      onTap: () async {
                                        await MediaGallerySaver().saveMediaFromUrl(url: msg.image!);
                                        myToast("Image Saved");
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
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


