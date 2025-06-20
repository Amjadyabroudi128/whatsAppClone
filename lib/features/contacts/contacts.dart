import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/padding.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/features/Settings/Widget/accountFunctions/signoutBtn.dart';
import '../../components/TextField.dart';
import 'Widgets/streamUser.dart';
class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService firebase =  FirebaseService();
  TextEditingController userController = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.addListener(_onSearched);
  }
  void _onSearched() {
    setState(() {
      searchQuery = userController.text;
    });
  }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    userController.removeListener(_onSearched);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
             signoutBtn()
            ],
            title: myPadding(
              padding: const EdgeInsets.only(top: 18),
              child: Text("Chats", style: Textstyles.appBar,),
            ),
            backgroundColor: myColors.TC,
            automaticallyImplyLeading: false,
            centerTitle: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: kTextField(
                  hint: "Search user",
                  myController: userController,
                ),
              ),
              userList(searchQuery, ),
            ],
          ),
      ),
    );
  }
}


