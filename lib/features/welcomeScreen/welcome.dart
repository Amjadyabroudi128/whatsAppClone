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
            padding: EdgeInsets.only(top: 99),
            child: Center(
              child: image(),
            ),
          ),
          BoxSpacing(myHeight: 50,),
          welcomeText(),
          BoxSpacing(myHeight: 13,),
          Text("You can Text, Family and friends ", style: Textstyles.read,),
          BoxSpacing(myHeight: 18,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: richText(),
          ),
          BoxSpacing(myHeight: 50,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 18)
            ),
            onPressed: (){},
            child: Text("Agree and Continue"),
          )
        ],
      ),
    );
  }
}



