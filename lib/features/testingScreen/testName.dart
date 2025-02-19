import 'package:flutter/material.dart';

class Testname extends StatefulWidget {
  final String? name;
  const Testname({super.key, this.name});

  @override
  State<Testname> createState() => _TestnameState();
}

class _TestnameState extends State<Testname> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello ${widget.name}"),
      ),
    );
  }
}
