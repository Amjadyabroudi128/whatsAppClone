import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';

import '../../../core/icons.dart';

class Starredmessages extends StatefulWidget {
  const Starredmessages({super.key});

  @override
  State<Starredmessages> createState() => _StarredmessagesState();
}

class _StarredmessagesState extends State<Starredmessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starred messages"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icons.noStar,
            BoxSpacing(myHeight: 9,),
            Text("No Starred Messages", style: Textstyles.noStarMessage,),
            Text("Tap and hold on a message to Star it, to Find it later ", style: TextStyle(fontSize: 16, ),)
          ],
        ),
      ),
    );
  }
}
