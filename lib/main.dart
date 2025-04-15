import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  await Supabase.initialize(
    url: "https://txtytzywyezmkwtsfxcy.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4dHl0enl3eWV6bWt3dHNmeGN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3MjUxMTgsImV4cCI6MjA2MDMwMTExOH0.Cn2bSE6ERAadltR4SGFlpZCV5-EJHPXrBKU7mk9w2Wk"
  );
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

  void _updateTheme(ThemeData newTheme) {
    if (mounted) {
      setState(() {
        _theme = newTheme;
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
      themeMode: ThemeMode.system,  // System theme (can be overridden)
      initialRoute: _auth.currentUser != null ? "btm" : "welcome",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "welcome": (context) => WelcomeScreen(),
        "pickColor": (context) => Colorpicking(),
        "contacts": (context) => Contacts(),
        "btm": (context) => Bottomnavbar(onThemeChange: _updateTheme),
      },
      home: Bottomnavbar(onThemeChange: _updateTheme),
    );
  }
}


