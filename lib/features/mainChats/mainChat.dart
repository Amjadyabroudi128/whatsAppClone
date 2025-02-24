import 'package:flutter/material.dart';
import 'package:whatsappclone/core/MyColors.dart';

class Mainchat extends StatefulWidget {
  final String? name;
  const Mainchat({super.key, this.name});

  @override
  State<Mainchat> createState() => _MainchatState();
}

class _MainchatState extends State<Mainchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats ${widget.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
        backgroundColor: myColors.TC,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text("Hello"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: (){},
        child: Icon(Icons.add),
      )
    );
  }
}
