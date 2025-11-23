import 'package:flutter/material.dart';

import '../../../../Firebase/FirebaseAuth.dart';
import '../../../../components/dividerWidget.dart';
import '../../../../components/flutterToast.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/TextStyles.dart';
import '../../../../core/icons.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final FirebaseService service = FirebaseService();
  String selectedImage = "Everyone";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile picture"),
      ),
      body:  SingleChildScrollView(
        padding: const .symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Who can see My Profile picture",style: Textstyles.whoOnline),
            kCard(
              child: Column(
                children: [
                  Options(
                    context: context,
                    label: const Text("Everyone"),
                    onTap: () async {
                      await service.imageVisibility("Everyone");
                      setState(() {
                        selectedImage = "Everyone";
                      });
                      myToast("Everyone can see your Image");
                    },
                    trailing: selectedImage == "Everyone"
                        ? icons.onlineStatus
                        : const SizedBox.shrink(),
                  ),
                  const divider(),
                  Options(
                    context: context,
                    label: const Text("Nobody"),
                    onTap: () async {
                      await service.imageVisibility("Nobody");
                      setState(() {
                        selectedImage = "Nobody";
                      });
                      myToast("Only you can see your Image");
                    },
                    trailing: selectedImage == "Nobody"
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
