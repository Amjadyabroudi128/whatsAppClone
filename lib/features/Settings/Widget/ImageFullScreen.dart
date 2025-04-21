import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/features/Settings/Widget/showSheet.dart';

import 'imageSheet.dart';

class FullScreenImageScreen extends StatefulWidget {
  final String imageUrl;

  const FullScreenImageScreen({super.key, required this.imageUrl});

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.transparent,
        title: Text("Profile Photo", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          kTextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white)
            ),
            onPressed: () async {
              await showImage(context);
            },
            child: Text("Edit", style: TextStyle(fontSize: 20),),
          )
          // PopupMenuButton<String>(
          //   icon: Icon(Icons.edit, color: Colors.white),
          //   onSelected: (value) {
          //     if (value == 'change') {
          //       // Trigger change photo logic
          //     } else if (value == 'delete') {
          //       // Trigger delete photo logic
          //     }
          //   },
          //   itemBuilder: (BuildContext context) => [
          //     const PopupMenuItem(
          //       value: 'change',
          //       child: Text('Change Photo'),
          //     ),
          //     const PopupMenuItem(
          //       value: 'delete',
          //       child: Text('Delete Photo'),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.imageUrl,
          child: Image.network(widget.imageUrl),
        ),
      ),
    );
  }

}
