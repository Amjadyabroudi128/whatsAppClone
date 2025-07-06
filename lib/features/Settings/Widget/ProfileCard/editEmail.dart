import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextButton.dart';
import 'package:whatsappclone/components/fSizedBox.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/TextField.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/iconButton.dart';
import '../../../../core/icons.dart';

class Editemail extends StatefulWidget {
  final String email;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const Editemail({
    super.key,
    required this.email,
    required this.emailController, 
    required this.passwordController,
  });

  @override
  State<Editemail> createState() => _EditemailState();
}

class _EditemailState extends State<Editemail> {
  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    OutlineInputBorder enabled = OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Colors.transparent
        )
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: fSizedBox(
        heightFactor: 0.94,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit your email"),
            actions: [
              kTextButton(
                onPressed: () async {
                  final newEmail = widget.emailController.text.trim();
                  if (newEmail.isEmpty) {
                    myToast("Your Email is empty");
                  } else if (newEmail == widget.email) {
                    myToast("Change something");
                  } else {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        bool localPasswordVisible = false; // local state
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text("Re-authenticate"),
                              content: kTextField(
                                maxLines: 1,
                                icon: kIconButton(
                                  myIcon: localPasswordVisible ? icons.visibility : icons.visibility_off,
                                  onPressed: () {
                                    setState(() {
                                      localPasswordVisible = !localPasswordVisible;
                                    });
                                  },
                                ),
                                myController: widget.passwordController,
                                label: Text("Password"),
                                obscureText: !localPasswordVisible,
                              ),
                              actions: [
                                kTextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                kTextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    if (widget.passwordController.text.isEmpty) {
                                      myToast("Add your password");
                                    } else {
                                      await service.authenticate(
                                        widget.email,
                                        widget.emailController.text.trim(),
                                        widget.passwordController.text.trim(),
                                      );
                                    }
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                    widget.emailController.clear();
                    widget.passwordController.clear();
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This is your Current Email"),
                BoxSpacing(myHeight: 10),
                kTextField(
                  filled: true,
                  maxLines: 1,
                  hint: widget.email,
                  enabled: false,
                ),
                BoxSpacing(myHeight: 10),
                Text("Change email"),
                BoxSpacing(myHeight: 10),
                kTextField(
                  icon: icons.emailIcon,
                  enable: enabled,
                  filled: true,
                  maxLines: 1,
                  hint: "e.g name@example.com",
                  myController: widget.emailController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
