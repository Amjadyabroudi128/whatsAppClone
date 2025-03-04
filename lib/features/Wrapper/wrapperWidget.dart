import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/features/testingScreen/testName.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("something is wrong ");
          } else {
            if(snapshot.data == null) {
              return WelcomeScreen();
            } else {
              return Testname();
            }
          }
        },
      ),
    );
  }
}
