import 'package:flutter/material.dart';
import 'package:whatsappclone/components/TextField.dart';
import 'package:whatsappclone/components/btmSheet.dart';
import 'package:whatsappclone/components/dividerContainer.dart';
import 'package:whatsappclone/core/MyColors.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/SizedBox.dart';
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
                padding: const .all(16),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const DividerContainer(),
                    Text("Choose an option", style: Textstyles.option),
                    const BoxSpacing(myHeight: 10),

                    // PHOTO (Gallery)
                    Options(
                      context: context,
                      leading: icons.image(context),
                      label: const Text("Photo"),
                      onTap: () async {
                        Navigator.of(context).pop();
                        widget.onUploadStatusChanged?.call(true);
                        final imageUrls = await url.pickMultiImages();
                        if (imageUrls.isEmpty) {
                          widget.onUploadStatusChanged?.call(false);
                          return;
                        }

                        for (final imageUrl in imageUrls) {
                          final result = await showImagePreview(imageUrl);
                          if (result != null && result.$1) {
                            await widget.service.sendMessage(
                              widget.widget.receiverId,
                              widget.widget.receiverName,
                              result.$2.trim(),
                              imageUrl,
                              null,
                              null,
                            );
                          }
                        }

                        widget.onUploadStatusChanged?.call(false);
                      },
                    ),

                    // CAMERA
                    Options(
                      context: context,
                      leading: icons.camera(context),
                      label: const Text("Camera"),
                      onTap: () async {
                        Navigator.pop(context);
                        widget.onUploadStatusChanged?.call(true);
                        final imageUrl = await url.takeImage();
                        if (imageUrl != null) {
                          final result = await showImagePreview(imageUrl);
                          if (result != null && result.$1) {
                            await widget.service.sendMessage(
                              widget.widget.receiverId,
                              widget.widget.receiverName,
                              result.$2.trim(),
                              imageUrl,
                              null,
                              null,
                            );
                          }
                        }

                        widget.onUploadStatusChanged?.call(false);
                      },
                    ),

                    // FILE
                    Options(
                      context: context,
                      leading: icons.file(context),
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
                            fileLink, // already uploaded URL
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
      myIcon: icons.add(context, MyColors.bDialog),
    );
  }


  Future<(bool, String)?> showImagePreview(String imageUrl) async {
    String caption = '';

    final result = await showDialog<(bool, String)?>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final size = MediaQuery.of(dialogCtx).size;

        return AlertDialog(
          insetPadding: .zero,
          contentPadding: const .all(7),
          content: SizedBox(
            width: size.width,
            height: size.height, // full height
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: .topLeft,
                    child: kIconButton(
                      onPressed: () {
                        FocusScope.of(dialogCtx).unfocus();
                        Navigator.of(dialogCtx).pop(null);
                      },
                      myIcon: icons.close,
                    ),
                  ),

                  Expanded(
                    flex: 9,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: .circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 420,
                            maxHeight: 420,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // CAPTION FIELD – takes remaining height
            Expanded(
              child: kTextField(
                hint: "Add a caption..",
                onChanged: (v) => caption = v,
                icon: kIconButton(
                  myIcon: icons.send,
                  onPressed: (){
                    FocusScope.of(dialogCtx).unfocus();
                    Navigator.of(dialogCtx).pop((true, caption));
                  },
                ),
              ),
            ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result;
  }
}
