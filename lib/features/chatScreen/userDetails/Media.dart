import 'package:flutter/material.dart';

class myMedia extends StatelessWidget {
  const myMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media"),
        centerTitle: true,
        actions: [

        ],
      ),
      body: Center(
        child: Text("Hello "),
      ),
    );
  }
}
