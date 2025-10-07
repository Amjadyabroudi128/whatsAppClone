import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';

import '../../../../core/icons.dart';

class ActiveStatus extends StatefulWidget {
  const ActiveStatus({super.key});

  @override
  State<ActiveStatus> createState() => _ActiveStatusState();
}

class _ActiveStatusState extends State<ActiveStatus> {
  String selectedOption = 'Everyone'; // Default selection
  bool isSelected = false;

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
              padding: const EdgeInsets.symmetric(horizontal: 4, ),
              child: Text(
                "Who can see when I'm online",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const BoxSpacing(myHeight: 16),
              kCard(
                child: Column(
                  children: [
                    Options(
                      context: context,
                      label: const Text("Everyone"),
                      onTap: () {
                        setState(() {
                          selectedOption = "Everyone";
                        });
                      },
                      trailing: selectedOption == "Everyone"
                          ? icons.onlineStatus
                          : const SizedBox.shrink(),
                    ),
                    const divider(),
                    Options(
                      context: context,
                      label: const Text("Nobody"),
                      onTap: () {
                        setState(() {
                          selectedOption = "Nobody";
                        });
                      },
                      trailing: selectedOption == "Nobody"
                          ? icons.onlineStatus
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

            const BoxSpacing(myHeight: 24),
          ],
        ),
      ),
    );
  }
}
