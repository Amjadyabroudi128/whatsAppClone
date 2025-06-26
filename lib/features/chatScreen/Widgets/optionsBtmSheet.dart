import 'package:flutter/material.dart';
import 'package:whatsappclone/components/btmSheet.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/SizedBox.dart';
import '../../../components/TextButton.dart';
import '../../../core/TextStyles.dart';
import '../../../components/iconButton.dart';
import '../../../components/listTilesOptions.dart';
import '../../../core/icons.dart';
import '../chatScreen.dart';
import 'package:whatsappclone/utils/pickImage.dart' as url;

class photoBtmSheet extends StatefulWidget {
   photoBtmSheet({
    super.key,
    required this.service,
    required this.widget,
    this.textColor,
     this.onUploadStatusChanged,
  });

  final FirebaseService service;
  final Testname widget;
  final Color? textColor;
   final void Function(bool)? onUploadStatusChanged;

  @override
  State<photoBtmSheet> createState() => _photoBtmSheetState();
}

class _photoBtmSheetState extends State<photoBtmSheet> {
  @override
  Widget build(BuildContext context) {
    return kIconButton(
      color: widget.textColor,
      onPressed: () {
        btmSheet(
          context: context,
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
                        onTap: () async {
                          Navigator.of(context).pop();
                          setState(() {
                            widget.onUploadStatusChanged?.call(true);
                          });
                          final imageUrls = await url.pickMultiImages();
                          if (imageUrls.isNotEmpty) {
                            for(String imageUrl in imageUrls) {
                              await widget.service.sendMessage(widget.widget.receiverId, widget.widget.receiverName, "", imageUrl, null, null);
                              setState(() {
                                widget.onUploadStatusChanged?.call(false);
                                Navigator.of(context).pop();
                              });
                            }
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
                            await widget.service.sendMessage(widget.widget.receiverId, widget.widget.receiverName, "", imageUrl, null, null);
                          }
                        }
                    ),
                    Options(context: context, leading: icons.file, label: Text("File"),
                        onTap: () async {
                          Navigator.pop(context);
                          final fileLink = await url.pickFile(); // Import this function
                          if (fileLink != null) {
                            await widget.service.sendMessage(widget.widget.receiverId, widget.widget.receiverName, "", null, fileLink, null);

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
