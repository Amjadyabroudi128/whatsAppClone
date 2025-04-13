import 'package:flutter/material.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';

import 'editBio.dart';

void ShowSheet (BuildContext context) {
  FirebaseService service = FirebaseService();
  showModalBottomSheet(context: context,
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