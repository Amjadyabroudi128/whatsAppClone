import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return kCard(
      child: Options(
          context: context,
          label: Text("Starred"),
          trailing: icons.arrowForward,
          leading: icons.star,
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
  }
}
