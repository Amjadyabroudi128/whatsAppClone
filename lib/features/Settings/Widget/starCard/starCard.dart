import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseCollections.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';
import 'allStars.dart';

class starCard extends StatelessWidget {
  const starCard({
    super.key,
    required this.user,
  });

  final User? user;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stars.doc(user!.email).collection
        ("messages").orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot){
        final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return kCard(
          child: Options(
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
          ),
        );
      },
    );

  }
}
