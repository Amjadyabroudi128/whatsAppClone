import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/dividerWidget.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';

class BioStatus extends StatefulWidget {
  const BioStatus({super.key});

  @override
  State<BioStatus> createState() => _BioStatusState();
}

class _BioStatusState extends State<BioStatus> {
  final FirebaseService service = FirebaseService();
  String selectedBio = "Everyone";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bio"),
      ),
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
