import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/flutterToast.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../core/icons.dart';

class ActiveStatus extends StatefulWidget {
  const ActiveStatus({super.key});

  @override
  State<ActiveStatus> createState() => _ActiveStatusState();
}

class _ActiveStatusState extends State<ActiveStatus> {
  String selectedOption = 'Everyone'; // Default selection
  String selectedBio = "Everyone";
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Status"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                  "Who can see when I'm online",
                  style: Textstyles.whoOnline
              ),
            ),
            const BoxSpacing(myHeight: 16),
            kCard(
              child: Column(
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
            const BoxSpacing(myHeight: 24),
             Text("Who can see My Bio",style: Textstyles.whoOnline),
      kCard(
        child: Column(
          children: [
            Options(
              context: context,
              label: const Text("Everyone"),
              onTap: () async {
                await service.bioVisibility("Everyone");
                setState(() {
                  selectedBio = "Everyone";
                });
                myToast("Everyone can see your bio");
              },
              trailing: selectedBio == "Everyone"
                  ? icons.onlineStatus
                  : const SizedBox.shrink(),
            ),
            const divider(),
            Options(
              context: context,
              label: const Text("Nobody"),
              onTap: () async {
                await service.bioVisibility("Nobody");
                setState(() {
                  selectedBio = "Nobody";
                });
                myToast("Only you can see your bio");
              },
              trailing: selectedBio == "Nobody"
                  ? icons.onlineStatus
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      )
      ],
        ),
      ),
    );
  }
}