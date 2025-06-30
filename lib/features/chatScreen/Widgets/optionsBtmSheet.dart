import 'package:flutter/material.dart';
import 'package:whatsappclone/components/btmSheet.dart';
import 'package:whatsappclone/components/dividerContainer.dart';

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
  const photoBtmSheet({
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
                    dividerContainer(),
                    Text(
                      "Choose an option",
                      style: Textstyles.option,
                    ),
                    const BoxSpacing(myHeight: 10),
                    Options(
                      context: context,
                      leading: icons.image,
                      label: const Text("Photo"),
                      onTap: () async {
                        Navigator.of(context).pop();
                        widget.onUploadStatusChanged?.call(true);
                        final imageUrls = await url.pickMultiImages();
                        if (imageUrls.isEmpty) {
                          widget.onUploadStatusChanged?.call(false); // User cancelled
                          return;
                        }

                        for (String imageUrl in imageUrls) {
                          await widget.service.sendMessage(
                            widget.widget.receiverId,
                            widget.widget.receiverName,
                            "",
                            imageUrl,
                            null,
                            null,
                          );
                        }
                        widget.onUploadStatusChanged?.call(false); // Upload done
                      },
                    ),
                    Options(
                      context: context,
                      leading: icons.dCam,
                      label: const Text("Camera"),
                      onTap: () async {
                        Navigator.pop(context);
                        widget.onUploadStatusChanged?.call(true);

                        final imageUrl = await url.takeImage();

                        if (imageUrl != null) {
                          await widget.service.sendMessage(
                            widget.widget.receiverId,
                            widget.widget.receiverName,
                            "",
                            imageUrl,
                            null,
                            null,
                          );
                        }

                        widget.onUploadStatusChanged?.call(false);
                      },
                    ),
                    Options(
                      context: context,
                      leading: icons.file,
                      label: const Text("File"),
                      onTap: () async {
                        Navigator.pop(context);
                        widget.onUploadStatusChanged?.call(true);

                        final fileLink = await url.pickFile();

                        if (fileLink != null) {
                          await widget.service.sendMessage(
                            widget.widget.receiverId,
                            widget.widget.receiverName,
                            "",
                            null,
                            fileLink,
                            null,
                          );
                        }

                        widget.onUploadStatusChanged?.call(false);
                      },
                    ),
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
