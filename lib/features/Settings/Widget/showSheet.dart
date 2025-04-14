import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';

import 'editBio.dart';

Future <void> ShowSheet (BuildContext context) async {
  await showModalBottomSheet(context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.94,
          child: Container(
              child: EditBio()
          ),

        );
      }
  );
}