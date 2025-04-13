import 'package:flutter/material.dart';

import 'editBio.dart';

void ShowSheet (BuildContext context) {
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