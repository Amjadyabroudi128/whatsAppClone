import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.title});

  final String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 90),
            child: Center(
              child: CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage("images/circular_crop.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}