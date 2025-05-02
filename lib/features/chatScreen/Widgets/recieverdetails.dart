import 'package:flutter/material.dart';

class userDetails extends StatelessWidget {
  const userDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users details"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
