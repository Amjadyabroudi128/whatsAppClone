import 'package:flutter/material.dart';
import 'package:whatsappclone/features/welcomeScreen/welcome.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomeScreen(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text("Hello ${widget.name}"),
      ),
    );
  }
}
