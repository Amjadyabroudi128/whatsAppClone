import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseCollections.dart';

import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';

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
        return kCard(
          child: Options(
              context: context,
              label: Row(
                children: [
                  Text("Favourite"),
                  Spacer(),
                  if (count > 0) Text(count.toString()),
                ],
              ),
              trailing: icons.myFavourite(context),
              onTap: (){
                Navigator.of(context).pushNamed("favourite");
              }
          ),
        );
      }
    );
  }
}
