import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/ColorHelper.dart';

import '../../components/TextStyles.dart';
import 'Widgets/richText.dart';
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
      backgroundColor: ColorHelper.BG,
      body:  Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 90),
            child: Center(
              child: image(),
            ),
          ),
          BoxSpacing(myHeight: 50,),
          welcomeText(),
          BoxSpacing(myHeight: 18,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: richText(),


          )
        ],
      ),
    );
  }
}



