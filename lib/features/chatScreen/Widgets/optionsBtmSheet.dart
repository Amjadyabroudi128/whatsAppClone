import 'package:flutter/material.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/SizedBox.dart';
import '../../../components/TextStyles.dart';
import '../../../components/iconButton.dart';
import '../../../components/listTilesOptions.dart';
import '../../../core/icons.dart';
import '../chatScreen.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;

class photoBtmSheet extends StatelessWidget {
  const photoBtmSheet({
    super.key,
    required this.service,
    required this.widget,
  });

  final FirebaseService service;
  final Testname widget;

  @override
  Widget build(BuildContext context) {
    return kIconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose an option",
                      style: Textstyles.option,
                    ),
                    const BoxSpacing(myHeight: 10),
                    Options(context: context,
                        leading: icons.image,
                        label: Text("Photo"),
                        onTap: ()async {
                          Navigator.pop(context);
                          final imageUrl = await url.pickImage();
                          if (imageUrl != null) {
                            await service.sendMessage(widget.receiverId, widget.receiverName, "", imageUrl, null, null);
                          }
                        }
                    ),
                    Options(
                        context: context,
                        leading: icons.dCam,
                        label: Text("Camera"),
                        onTap: () async {
                          Navigator.pop(context);
                          final imageUrl = await url.takeImage();
                          if (imageUrl != null) {
                            await service.sendMessage(widget.receiverId, widget.receiverName, "", imageUrl, null, null);
                          }
                        }
                    ),
                    Options(context: context, leading: icons.file, label: Text("File"),
                        onTap: () async {
                          Navigator.pop(context);
                          final fileLink = await url.pickFile(); // Import this function
                          if (fileLink != null) {
                            await service.sendMessage(widget.receiverId, widget.receiverName, "", null, fileLink, null);

                          }
                        }),
                  ],
                ),
              ),
            );
          },
        );

      },
      myIcon: icons.add,
    );
  }
}
