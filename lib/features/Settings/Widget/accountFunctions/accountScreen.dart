import 'package:flutter/material.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/deleteAccount.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/signout.dart';

import '../../../../components/SizedBox.dart';
import 'changeEmail.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.passwordController, required this.email, required this.emailController});
  final TextEditingController passwordController;
  final String email;
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
          elevation: 0,
        ),
      body:  SingleChildScrollView(
        padding: const .symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const BoxSpacing(myHeight: 16),
            kCard(
              child: Column(
                children: [
                  const deleteAccount(),
                  const divider(),
                  ChangeEmail(passwordController: passwordController,
                      email: email,
                      emailController: emailController),
                  const divider(),
                  const signOut(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
