import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseCollections.dart';

import '../../../../components/dividerWidget.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';
import '../starCard/allStars.dart';

class favouriteCard extends StatelessWidget {
  const favouriteCard({
    super.key,
    this.user,
  });
  final User? user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favourites.doc(user!.email).collection("myFavourites").snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return Column(
          children: [
            kCard(
              child: Column(
                children: [
                  Options(
                      context: context,
                      label: Row(
                        children: [
                          const Text("Favourite"),
                          const Spacer(),
                          if (count > 0) Text(count.toString()),
                        ],
                      ),
                      trailing: icons.myFavourite(context),
                      onTap: (){
                        Navigator.of(context).pushNamed("favourite");
                      }
                  ),
                  const divider(),
                  StreamBuilder(
                    stream: stars.doc(user!.email).collection
                      ("messages").orderBy("timestamp", descending: true).snapshots(),
                    builder: (context, snapshot){
                      final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                      return Options(
                          context: context,
                          label: Row(
                            children: [
                              const Text("Starred"),
                              const Spacer(),
                              if (count > 0) Text(count.toString()),
                            ],
                          ),
                          trailing: icons.arrowForward(context),
                          leading: icons.star(context),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => allStarred(receiverId: user!.email),
                              ),
                            );
                          }
                      );
                    },
                  )
                ],
              ),
            ),

          ],
        );
      }
    );
  }
}
