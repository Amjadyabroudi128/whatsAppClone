import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/padding.dart';
import '../../core/MyColors.dart';
import 'Widgets/ElevatedButton.dart';
import 'Widgets/richText.dart';
import 'Widgets/textFamily.dart';
import 'Widgets/welcome text.dart';
import 'Widgets/whatsappImage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key,});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: myColors.BG,
      body:  const SingleChildScrollView(
        child:  Column(
          children: [
            myPadding(
              padding: EdgeInsets.only(top: 99),
              child: Center(
                child: image(),
              ),
            ),
            BoxSpacing(myHeight: 50,),
            welcomeText(),
            BoxSpacing(myHeight: 13,),
            textFamily(),
            BoxSpacing(myHeight: 18,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: richText(),
            ),
            BoxSpacing(myHeight: 50,),
            elevatedBtn()
          ],
        ),
      ),
    );
  }
}





