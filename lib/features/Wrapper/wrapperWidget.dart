import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/features/mainChats/mainScreen.dart';
import 'package:whatsappclone/features/testingScreen/testName.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.idTokenChanges(), // Change here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong", style: TextStyle(fontSize: 16)),
            );
          }

          // Check if user is signed in or not
          if (snapshot.data == null) {
            return const WelcomeScreen();
          } else {
            return const MainScreen();
          }
        },
      ),
    );
  }
}
