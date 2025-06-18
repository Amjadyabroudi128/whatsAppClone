
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/colorPicker/ColorPicking.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/Media.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';
import 'features/BottomNavBar/BottomNavBar.dart';
import 'features/welcomeScreen/welcome.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use Debug for testing
    appleProvider: AppleProvider.debug,
  );
  // await FirebaseMessaging.instance.subscribeToTopic("messages");
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _theme = myTheme.appTheme; // Default to light theme
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ThemeMode _themeMode = ThemeMode.system; // default

  void _updateTheme(ThemeData newTheme, ThemeMode newMode) {
    if (mounted) {
      setState(() {
        _theme = newTheme;
        _themeMode = newMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _theme,  // Light theme
      darkTheme: myTheme.darkTheme,  // Dark theme
      themeMode: _themeMode, // Now controlled manually
      initialRoute: _auth.currentUser != null ? "btm" : "welcome",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "welcome": (context) => WelcomeScreen(),
        "pickColor": (context) => Colorpicking(),
        "contacts": (context) => Contacts(),
        "btm": (context) => Bottomnavbar(onThemeChange: _updateTheme),
        "mediaScreen": (context) => MyMedia(),
      },
      home: Bottomnavbar(onThemeChange: _updateTheme),
    );
  }
}
