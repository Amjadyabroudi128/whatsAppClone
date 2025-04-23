import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextStyles.dart';
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
        title: Text("Profile Photo", style: Textstyles.editProfile,),
        centerTitle: true,
        actions: [
          kTextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white)
            ),
            onPressed: () async {
              await showImage(context);
            },
            child: Text("Edit", style: Textstyles.editProfile,),
          )
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
