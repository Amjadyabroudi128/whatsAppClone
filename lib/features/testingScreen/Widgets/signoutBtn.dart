import 'package:flutter/material.dart';

import '../../../components/iconButton.dart';
import '../../../components/icons.dart';
import '../../welcomeScreen/welcome.dart';

class signoutBtn extends StatelessWidget {
  const signoutBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kIconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      },
      myIcon: icons.logout,
    );
  }
}
