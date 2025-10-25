import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
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
  bool hasFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favourites"),
        actions: [
          if(hasFavourites)
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: kCard(
                 child: Options(
                   context: context,
                   leading: icons.add(context, Theme.of(context).iconTheme.color),
                   label: const Text("Add people"),
                   onTap: (){
                     _showAddUsersDialog();
                   }
                 ),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Favourites")
                  .doc(userEmail)
                  .collection("myFavourites")
                  .snapshots(),
              builder: (context, snapshot) {
                bool currentFave = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                if (hasFavourites != currentFave) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        hasFavourites = currentFave;
                        if (!hasFavourites) {
                          isEditing = false; // Reset editing mode when no messages
                          selectedMessages.clear();
                        }
                      });
                    }
                  });
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icons.myFavourite(context, size: 80),
                        const BoxSpacing(myHeight: 10,),
                         Text("No Favourite yet", style: Textstyles.noStarMessage),
                        const BoxSpacing(myHeight: 10,),
                        const Text(
                          "add user to favourite to see it here ",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
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
                                  final removedItems = List<String>.from(selectedMessages);
                                  for (final name in removedItems) {
                                    await service.removeFavourite(name);
                                  }

                                  // Show SnackBar with Undo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 2,
                                      behavior: SnackBarBehavior.floating,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      content: Text("$removedItems removed from favourites"),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () async {
                                          for (final name in removedItems) {
                                            await service.addToFavourite(name);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );

                                  // Clear selection state
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
          ),
        ],
      ),
    );
  }
  void _showAddUsersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Dialog-local selection
        final Set<String> selected = {};
            return AlertDialog(
              title: Row(
                children: [
                  const Text("Add to Favourites"),
                  Spacer(),
                  TextButton(
                    onPressed: selected.isEmpty
                        ? null
                        : () async {
                      for (final name in selected) {
                        await service.addToFavourite(name);
                        myToast("added To favourite");
                      }
                    },
                    child: Text(
                      selected.isEmpty ? "Add" : "done",
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 420,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("email", isNotEqualTo: userEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text("No users available"));
                          }
                          final users = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userData = users[index].data() as Map<String, dynamic>;
                              final userName = (userData['name'] ?? 'Unknown') as String;
                              final userBio = (userData['bio'] ?? '') as String;
                              final userImage = (userData['image'] ?? '') as String;

                              return FutureBuilder<bool>(
                                future: service.isFavourite(userName),
                                builder: (context, favSnapshot) {
                                  final isAlreadyFavourite = favSnapshot.data ?? false;

                                  Widget trailingWidget;
                                  if (isAlreadyFavourite) {
                                    trailingWidget = icons.onlineStatus;
                                  } else {
                                    trailingWidget = Checkbox(
                                      activeColor: MyColors.online,
                                      value: selected.contains(userName),
                                      onChanged: (checked) {
                                        setState(() {
                                          if (checked == true) {
                                            selected.add(userName);
                                          } else {
                                            selected.remove(userName);
                                          }
                                        });
                                      },
                                    );
                                  }

                                  return Options(
                                    context: context,
                                    subtitle: userBio.isNotEmpty ? Text(userBio) : null,
                                    leading: userImage.isNotEmpty
                                        ? const Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: CircleAvatar(radius: 20), // image below
                                    )
                                        : CircleAvatar(
                                      radius: 20,
                                      child: Text(userName.isNotEmpty ? userName[0] : '?'),
                                    ),
                                    label: Text(userName),
                                    trailing: trailingWidget,
                                    onTap: isAlreadyFavourite
                                        ? null
                                        : () {
                                      setState(() {
                                        if (selected.contains(userName)) {
                                          selected.remove(userName);
                                        } else {
                                          selected.add(userName);
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),

              ],
            );
          },
        );

  }
}
