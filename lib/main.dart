import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/colorPicker/ColorPicking.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';
import 'features/BottomNavBar/BottomNavBar.dart';
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
  ThemeData _theme = myTheme.appTheme;

  void _updateTheme(ThemeData newTheme) {
    if (mounted) {
      setState(() {
        _theme = newTheme;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _theme,
      darkTheme: myTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: "welcome",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "welcome" : (context) => WelcomeScreen(),
        "pickColor": (context) => Colorpicking(),
        "contacts": (context) => Contacts(),
        "btm": (context) => Bottomnavbar()
      },
      home:  Bottomnavbar(onThemeChange: _updateTheme),
    );
  }
}

