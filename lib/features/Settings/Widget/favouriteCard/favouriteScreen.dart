import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextButton.dart';
import '../../../../components/iconButton.dart';
import '../../../../core/MyColors.dart';
import '../../../../core/TextStyles.dart';
import '../../../../core/icons.dart';

class Favouritescreen extends StatefulWidget {
  const Favouritescreen({super.key});

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

class _FavouritescreenState extends State<Favouritescreen> {
  final String userEmail = FirebaseAuth.instance.currentUser!.email!;
  FirebaseService service = FirebaseService();
  bool isEditing = false;
  Set<String> selectedMessages = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favourites"),
        actions: [
          kTextButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                selectedMessages.clear();
              });
            },
            child: Text(
              isEditing ? "Cancel" : "Edit",
              style: Textstyles.editBar,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favourites")
            .doc(userEmail)
            .collection("myFavourites")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favourites yet."));
          }

          final favourites = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Favourites",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      final favData =
                      favourites[index].data() as Map<String, dynamic>;
                      final name = favData['name'] ?? 'Unknown';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isEditing)
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    activeColor: MyColors.starColor,
                                    value: selectedMessages.contains(name),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedMessages.add(name);
                                        } else {
                                          selectedMessages.remove(name);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            Flexible(
                              child: kCard(
                                child: Options(
                                  context: context,
                                  label: Text(name),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (isEditing && selectedMessages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kIconButton(
                          onPressed: () async {
                            for (final name in selectedMessages) {
                              await service.removeFavourite(name);
                              myToast("Removed from Favourites");
                            }
                            setState(() {
                              isEditing = false;
                              selectedMessages.clear();
                            });
                          },
                          myIcon: icons.deleteIcon,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
