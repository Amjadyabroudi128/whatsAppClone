import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class userDetails extends StatelessWidget {
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? bio;
  const userDetails({super.key, this.name, this.email, this.imageUrl, this.bio});

  @override
  Widget build(BuildContext context) {
    int count= 0 ;
    int imageCount = 0;
    return Scaffold(
      backgroundColor: myColors.BG,
      appBar: AppBar(
        backgroundColor: myColors.BG,
        title: Text("Contact Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              imageUrl == null || imageUrl!.isEmpty ?
                  kimageNet(
                    src:"https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                  )
              : kCard(
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: kimageNet(src: imageUrl!),
              ), 
              // : kimageNet(src: imageUrl!,),
              BoxSpacing(myHeight: 9,),
              Text("${name}", style: Textstyles.recieverName,),
              BoxSpacing(myHeight: 7,),
              Text("$email", style: Textstyles.recieverEmail,),
              bio!.isEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox.shrink()
              ) : kCard(
                color: myColors.FG,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${bio}", style: Textstyles.bioStyle,),
                ),
                // child: kL("${bio}", style: Textstyles.bioStyle,),
              ),
              BoxSpacing(myHeight: 5,),
              Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("starred-messages")
                        .doc(FirebaseAuth.instance.currentUser!.email).collection("messages").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        count = snapshot.data!.docs.length;
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return kCard(
                          color: myColors.familyText,
                          child: Column(
                            children: [
                              Options(
                                  context: context,
                                  leading: icons.star,
                                  label: Row(
                                    children: [
                                      Text("Starred messages"),
                                      Spacer(),
                                      Text("None")
                                    ],
                                  ),
                                  trailing: icons.arrowForward,
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Starredmessages()
                                      ),
                                    );
                                  }
                              ),
                              divider(),
                              Options(
                                context: context,
                                leading: icons.image,
                                label: Row(
                                  children: [
                                    Text("Media"),
                                    Spacer(),
                                    Text("None"),
                                  ],
                                ),
                                trailing: icons.whiteImage,
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyMedia()
                                    ),
                                  );
                                }
                              )
                            ],
                          ),
                        );
                      }
                      return kCard(
                        color: myColors.familyText,
                        child: Column(
                          children: [
                            Options(
                              context: context,
                              leading: icons.star,
                              label: Row(
                                children: [
                                  Text("Starred messages"),
                                  Spacer(),
                                  Text("${count.toString()}")
                                ],
                              ),
                              trailing: icons.arrowForward,
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Starredmessages()
                                  ),
                                );
                              }
                            ),
                            divider(),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("media")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("messages")
                                    .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  imageCount = snapshot.data!.docs.length;
                                }
                                return Options(
                                    context: context,
                                    leading: icons.image,
                                    label: Row(
                                      children: [
                                        Text("Media"),
                                        Spacer(),
                                        Text("${imageCount.toString()}"),
                                      ],
                                    ),
                                    trailing: icons.arrowForward,
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MyMedia()
                                        ),
                                      );
                                    }
                                );
                              }
                            )
                          ],
                        ),
                      );
                    }
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
