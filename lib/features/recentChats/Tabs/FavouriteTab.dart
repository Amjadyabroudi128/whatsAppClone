import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/UserCircleAvatar.dart';
import '../../../components/SizedBox.dart';
import '../../../components/kCard.dart';
import '../../../components/listTilesOptions.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
class FavouriteTab extends StatelessWidget {
  const FavouriteTab({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Favourites")
          .doc(user!.email)
          .collection("myFavourites")
          .snapshots(),
      builder: (context, snap){
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasError) {
          return Center(
            child: Text(
              'Something went wrong\n${snap.error}',
              textAlign: .center,
            ),
          );
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icons.myFavourite(context, size: 80),
                const BoxSpacing(myHeight: 10),
                Text("No Favourite yet", style: Textstyles.noStarMessage),
                const BoxSpacing(myHeight: 10),
                const Text(
                  "add user to favourite to see it here ",
                  style: TextStyle(fontSize: 16),
                  textAlign: .center,
                ),
              ],
            ),
          );
        }
        final favourites = snap.data!.docs;

        return Padding(
          padding: const .all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: const .all(8.0),
                child: Text(
                  "Favourites",
                  style: Textstyles.favourite,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final favData =
                    favourites[index].data();
                    final name = favData['name'] ?? 'Unknown';
                    final image = favData["image"] ?? "";
                    return Padding(
                      padding: const .symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: .start,
                        children: [
                          Flexible(
                            child: kCard(
                              child: Options(
                                context: context,
                                label: Row(
                                  children: [
                                    image.isNotEmpty ? CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(image),
                                      radius: 20,
                                    ) : userNamecircle(otherUserName: name),
                                    const BoxSpacing(mWidth: 8,),
                                    Text(name),
                                  ],
                                ),
                              ),
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

      },
    );
  }
}
