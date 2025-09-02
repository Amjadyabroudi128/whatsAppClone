import 'package:flutter/material.dart';

import '../../../../components/btmSheet.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';
import '../ProfileCard/editEmail.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key, required this.passwordController, required this.email, required this.emailController});
  final TextEditingController passwordController;
  final String email;
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Options(
        context: context,
        label: Text("Change email"),
        trailing: icons.emailIcon(context),
        onTap: ()async {
          await btmSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Editemail(email: email, emailController: emailController,
                  passwordController: passwordController,);
              }
          );
        }
    );
  }
}
