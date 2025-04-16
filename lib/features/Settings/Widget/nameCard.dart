import 'dart:io';
import 'dart:typed_data'; // ✅ Correct import for Uint8List
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/dividerWidget.dart';
import 'package:whatsappclone/features/Settings/Widget/showSheet.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../core/icons.dart';
import '../../../utils/pickImage.dart';

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
  String? uploadedImageUrl;

  final supabase = Supabase.instance.client;
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

  File? imageFile;
  Future pickImage() async {
    final ImagePicker image = ImagePicker();
    final XFile? file = await image.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  Future uploadImage() async {
    if (imageFile == null) {
      myToast("No image selected");
      return;
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "profile_images/$fileName.jpg";

    try {
      await supabase.storage.from("usersprofile").upload(path, imageFile!);

      // Get the public URL of the uploaded image
      final imageUrl = supabase.storage.from("usersprofile").getPublicUrl(path);

      myToast("Uploaded image");

      // Display the image from the URL
      setState(() {
        uploadedImageUrl = imageUrl;
      });
    } catch (e) {
      myToast("Failed to upload the image: $e");
    }
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
              child: uploadedImageUrl != null
                  ? Image.network(uploadedImageUrl!,
                      fit: BoxFit.cover, height: 200) : imageFile != null
                  ? Image.file(imageFile!, fit: BoxFit.cover, height: 200)
                  : Image.network(
                "https://media.licdn.com/dms/image/v2/C5603AQGWALNlfWBXcA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1634729409931?e=1749686400&v=beta&t=uE3GxROfoynmR_1PjjxcMbumU-JgwfruBzZBTlrDkPA",
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Positioned(
              bottom: 0,
              right: -17,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 29,
                ),
                onPressed: () {
                  pickImage();
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
}
