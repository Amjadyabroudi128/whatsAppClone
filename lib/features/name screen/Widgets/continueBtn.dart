// import 'package:flutter/material.dart';
// import 'package:whatsappclone/components/ElevatedBtn.dart';
// import 'package:whatsappclone/components/scaffoldMessanger.dart';
//
// import '../../testingScreen/testName.dart';
//
// class continueBtn extends StatelessWidget {
//   const continueBtn({
//     super.key,
//     required this.name,
//   });
//
//   final TextEditingController name;
//
//   @override
//   Widget build(BuildContext context) {
//     return kElevatedBtn(
//       child: Text("Continue"),
//       onPressed: (){
//         if (name.text.isNotEmpty) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Testname(name: name.text),
//             ),
//           );
//         } else {
//           showSnackbar(context,"Please Enter your name");
//         }
//       },
//
//     );
//   }
// }
