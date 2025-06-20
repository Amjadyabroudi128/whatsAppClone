import 'package:flutter/material.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import 'package:whatsappclone/components/kCard.dart';

class imageWidget extends StatelessWidget {
  const imageWidget({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl == null || imageUrl!.isEmpty ?  kCard(
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 100, // set a size to make the card visible
        height: 100,
        child: Center(
          child: Text(
            "Add Photo",
            style: Textstyles.addPhoto,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ) : Image.network(imageUrl!, fit: BoxFit.cover, height: 200, width: 200,);
  }
}
