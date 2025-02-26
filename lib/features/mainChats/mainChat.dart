import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextStyles.dart';
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
        title: Text("Chats ${widget.name}", style: Textstyles.appBar,),
        backgroundColor: myColors.TC,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text("Hello"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      )
    );
  }
}
