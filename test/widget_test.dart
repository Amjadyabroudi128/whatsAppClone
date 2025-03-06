import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsappclone/components/Strings.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/features/SignInScreen/signIn.dart';
import 'package:whatsappclone/features/SignUp/signupScreen.dart';
import 'package:whatsappclone/features/welcomeScreen/Widgets/welcome%20text.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });
  testWidgets('welcomeText displays correct text', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: welcomeText(),
      ),
    ));

    // Verify that the text widget contains the expected welcome text
    expect(find.text(Strings.Welcome), findsOneWidget);
  });
}
