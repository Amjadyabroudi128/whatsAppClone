import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/dividerWidget.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/TextStyles.dart';
import '../../../../core/icons.dart';

class LastSeen extends StatefulWidget {
  const LastSeen({super.key});

  @override
  State<LastSeen> createState() => _LastSeenState();
}

class _LastSeenState extends State<LastSeen> {
  String selectedOption = 'Everyone'; // Default selection
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Last Seen "),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                  "Who can see when I'm online",
                  style: Textstyles.whoOnline
              ),
            ),
            kCard(
              child:  Column(
                children: [
                  Options(
                    context: context,
                    label: const Text("Everyone"),
                    onTap: () async {
                      await service.setOnlineVisibility("Everyone");
                      setState(() {
                        selectedOption = "Everyone";
                      });
                      myToast("Your status is now visible");
                    },
                    trailing: selectedOption == "Everyone"
                        ? icons.onlineStatus
                        : const SizedBox.shrink(),
                  ),
                  const divider(),
                  Options(
                    context: context,
                    label: const Text("Nobody"),
                    onTap: () async {
                      await service.setOnlineVisibility("Nobody");
                      setState(() {
                        selectedOption = "Nobody";
                      });
                      myToast("Only you can see your status ");
                    },
                    trailing: selectedOption == "Nobody"
                        ? icons.onlineStatus
                        : const SizedBox.shrink(),
                  ),

                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
