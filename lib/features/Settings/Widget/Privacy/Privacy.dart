import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/features/Settings/Widget/Privacy/ActiveStatus.dart';
import 'package:whatsappclone/features/Settings/Widget/Privacy/BioStatus.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../core/icons.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _ActiveStatusState();
}

class _ActiveStatusState extends State<PrivacyScreen> {
  String selectedOption = 'Everyone'; // Default selection
  String selectedBio = "Everyone";
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BoxSpacing(myHeight: 16),
            kCard(
              child: Options(
                context: context,
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LastSeen()
                    ),
                  );
                },
                label: const Text("Last seen & online"),
                trailing: icons.arrowForward(context),
              ),
            ),
            const BoxSpacing(myHeight: 6),
             kCard(
               child: Options(
                 context: context,
                 onTap: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (_) => const BioStatus()
                     ),
                   );
                 },
                 trailing: icons.arrowForward(context),
                 label: const Text("My Bio")
               ),
             )
      ],
        ),
      ),
    );
  }
}