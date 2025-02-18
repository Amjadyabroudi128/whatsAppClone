import 'package:flutter/material.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/name%20screen/name.dart';

import 'features/welcomeScreen/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: myTheme.appTheme,
      routes: {
        "sign up": (context) => const Signupscreen(),
        "nameScreen": (context) => NameScreen(),
      },
      home: const WelcomeScreen(),
    );
  }
}

