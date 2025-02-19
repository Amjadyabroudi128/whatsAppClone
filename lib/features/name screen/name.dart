import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';

import '../SignUp/Widgets/signupBtn.dart';
import '../testingScreen/Widgets/continueBtn.dart';
import '../testingScreen/testName.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("PLEASE PROVIDE YOUR NAME"),
              SizedBox(height: 20,),
              kTextField(
                keyBoard: TextInputType.emailAddress,
                myController: name,
                border: OutlineInputBorder(),
                myIcon: Icon(Icons.person),
                label: Text("Name"),
              ),
              continueBtn(name: name)
            ],
          ),
        ),
      ),
    );
  }
}

