import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;
import 'imageSheet.dart';

class FullScreenImageScreen extends StatefulWidget {
  final String imageUrl;

  const FullScreenImageScreen({super.key, required this.imageUrl});

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text("Profile Photo", style: Textstyles.editProfile),
        centerTitle: true,
        actions: [
          kTextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () async {
              await showImage(
                context,
                addToFirebase: (String path) async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user!.uid)
                      .update({"image": path});
                },
              );
            },
            child: Text("Edit", style: Textstyles.editProfile),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const CircularProgressIndicator();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final updatedImage = data["image"] ?? "";

            if (updatedImage.isEmpty) {
              return const Text(
                "No image available",
                style: TextStyle(color: Colors.white),
              );
            }

            return Hero(
              tag: updatedImage,
              child: Image.network(updatedImage),
            );
          },
        ),
      ),
    );
  }
}
