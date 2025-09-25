import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/colorPicker/ColorPicking.dart';
import 'package:whatsappclone/core/appTheme.dart';
import 'package:whatsappclone/features/SignInScreen/signIn.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/chatScreen/chatScreen.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/Media.dart';
import 'package:whatsappclone/features/contacts/contacts.dart';
import 'Firebase/FirebaseAuth.dart';
import 'Firebase/online/offline.dart';
import 'Firebase/passwordReset.dart';
import 'features/BottomNavBar/BottomNavBar.dart';
import 'features/Settings/Widget/favouriteCard/favouriteScreen.dart';
import 'features/welcomeScreen/welcome.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Handling a background message: ${message.messageId}');
}
late final PresenceController presence;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  final service = FirebaseService();
  presence = PresenceController(service);
  presence.attach();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _theme = MyTheme.appTheme;
  ThemeMode _themeMode = ThemeMode.system;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    await _requestPermissionAndSaveToken();

    // Handle notification tap when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Handle when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap(message);
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Received foreground message: ${message.notification?.title}');
    });

    // Optional: auto-refresh token when it changes
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));

        print('🔁 Token refreshed and saved: $token');
      }
    });
  }

  Future<void> _requestPermissionAndSaveToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted notification permission');

      final token = await messaging.getToken();
      print('📱 Current device FCM token: $token');

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && token != null) {
        // SAVE TOKEN TO FIRESTORE
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));

        print('✅ FCM token saved for user: ${user.uid}');
      } else {
        print('⚠️ Could not save token: user or token is null');
      }
    } else {
      print('❌ Notification permission denied');
    }
  }


  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;

    if (data['type'] == 'chat') {
      final receiverId = data['receiverId'];
      final receiverName = data['receiverName'];
      final image = data['image'];
      print("➡️ Navigating to chat with $receiverName ($receiverId)");

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => Testname(
            receiverId: receiverId,
            receiverName: receiverName,
            image: image,
          ),
        ),
      );
    }
  }
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _theme,
      darkTheme: MyTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: _auth.currentUser != null ? "btm" : "welcome",
      routes: {
        "sign up": (context) => const Signupscreen(),
        "login": (context) => const SignInscreen(),
        "welcome": (context) => const WelcomeScreen(),
        "passReset": (context) => const PasswordReset(),
        "pickColor": (context) => const Colorpicking(),
        "contacts": (context) => const Contacts(),
        "btm": (context) => Bottomnavbar(onThemeChange: _updateTheme),
        "mediaScreen": (context) => const MyMedia(),
        "favourite" : (context) => const Favouritescreen()
      },
      home: Bottomnavbar(onThemeChange: _updateTheme),
    );
  }
}
