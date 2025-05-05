// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:whatsappclone/Firebase/FirebaseAuth.dart';
// import 'package:whatsappclone/messageClass/messageClass.dart';
//
// import '../../../components/TextButton.dart';
// import '../../../components/TextStyles.dart';
// import '../../../components/flutterToast.dart';
// import '../../../core/icons.dart';
//
// PopupMenuItem<String> starMessage(FirebaseService service, Messages msg, BuildContext context, bool isStarred) {
//   return PopupMenuItem(
//     value: "Star",
//     child: kTextButton(
//       child: Row(
//         children: [
//           Text(isStarred ? "Unstar" : "Star", style: Textstyles.copyMessage),
//           Spacer(),
//           isStarred ? Icon(Icons.star, color: Colors.amber) : icons.star,
//         ],
//       ),
//       onPressed: () {
//         setState(() async {
//           isStarred = !isStarred;
//           if(isStarred)  {
//             service.DeleteStar(msg.text);
//             myToast("message unstarred");
//           } else {
//             await service.addToStar(msg.text);
//             myToast("message starred");
//           }
//         });
//         Navigator.pop(context);
//       },
//     ),
//   );
// }
