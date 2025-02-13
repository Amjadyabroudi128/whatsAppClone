import 'package:flutter/material.dart';
import 'package:whatsappclone/core/ColorHelper.dart';

import '../../TextStyles.dart';
import 'Widgets/whatsappImage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.title});

  final String title;

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
          SizedBox(height: 50,),
          Text("Welcome to WhatsApp", style: Textstyles.welcome,),

        ],
      ),
    );
  }
}

