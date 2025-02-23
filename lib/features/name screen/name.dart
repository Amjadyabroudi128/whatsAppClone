import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import '../testingScreen/Widgets/continueBtn.dart';
import 'Widgets/nameTField.dart';

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
              BoxSpacing(myHeight: 20,),
              nameTextField(name: name),
              BoxSpacing(myHeight: 14,),
              continueBtn(name: name)
            ],
          ),
        ),
      ),
    );
  }
}


