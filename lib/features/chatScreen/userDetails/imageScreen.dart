import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/iconButton.dart';
import '../../../core/icons.dart';
import 'Widgets/btmSheet.dart';

class Imagescreen extends StatefulWidget {
  final String date;
  final senderName;
  final String time;
  final String? image;
  const Imagescreen({super.key, required this.date, required this.senderName, required this.time, this.image});

  @override
  State<Imagescreen> createState() => _ImagescreenState();
}

class _ImagescreenState extends State<Imagescreen> {
  final TextStyle dates = TextStyle(fontSize: 13);
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.senderName == auth.currentUser!.email ? "You" : widget
                  .senderName ?? "",
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
            kIconButton(
              myIcon: icons.deleteIcon,
              onPressed: () async {
                await showBtmSheet(context, widget.image, widget.senderName);
              },
            ),
            // BoxSpacing(mWidth: 14,),
            IconButton(
              icon: icons.star,
              onPressed: () {

              },
            ),
            // BoxSpacing(mWidth: 14,),
            IconButton(
              icon: Icon(CupertinoIcons.share),
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
