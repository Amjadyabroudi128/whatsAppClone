import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/Wrapper/wrapperWidget.dart';
import 'features/testingScreen/testName.dart';
import 'features/welcomeScreen/welcome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system, // theme depends on system
      theme: myTheme.appTheme,
      darkTheme: myTheme.appTheme,
      // initialRoute: "nameScreen",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "test": (context) => Testname(),
        // "nameScreen": (context) => NameScreen(),
        "welcome" : (context) => WelcomeScreen(),
        "wrapper" : (context) => Wrapper(),
      },
      home: Wrapper(),
    );
  }
}

