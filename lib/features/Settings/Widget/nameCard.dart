import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/editBio.dart';

import '../../../core/icons.dart';

class nameCard extends StatefulWidget {
  const nameCard({
    super.key,
    required this.userName,
  });

  final dynamic userName;

  @override
  State<nameCard> createState() => _nameCardState();
}

class _nameCardState extends State<nameCard> {
  final TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Image.network("https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
              height: 200,
            ),
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
          ),
          Card(
            color: myColors.CardColor,
            child: ListTile(
              title: Text(widget.userName),
              subtitle: ListTile(
                title: Text("your bio"),
                trailing: IconButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBio(),
                    ),
                  );
                }, icon: Icon(Icons.edit)),
              ),
              // subtitle: kTextField(
              //   hint: "your bio",
              //   myController: bioController,
              // ),
        ),
      )
        ],
      ),
    );
    // return Card(
    //   color: myColors.CardColor,
    //   child: ListTile(
    //     title: Text(userName),
    //     leading: icons.person,
    //   ),
    // );
  }
}
