import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/name%20screen/name.dart';

import 'features/welcomeScreen/welcome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // initialRoute: "nameScreen",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "nameScreen": (context) => NameScreen(),
        "welcome" : (context) => WelcomeScreen(),
      },
      home: const WelcomeScreen(),
    );
  }
}

