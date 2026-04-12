import 'package:flutter/material.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/deleteAccount.dart';

import '../../../../components/SizedBox.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
          centerTitle: true,
          elevation: 0,
        ),
      body:  const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            BoxSpacing(myHeight: 16),
            kCard(
              child: Column(
                children: [
                  deleteAccount(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
