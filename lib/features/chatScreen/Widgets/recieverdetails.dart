import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/kCard.dart';

class userDetails extends StatelessWidget {
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? bio;
  const userDetails({super.key, this.name, this.email, this.imageUrl, this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            imageUrl == null || imageUrl!.isEmpty ?
                kimageNet(
                  src:"https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                )
                : kimageNet(src: imageUrl!,),
            BoxSpacing(myHeight: 9,),
            Text("${name}", style: Textstyles.recieverName,),
            BoxSpacing(myHeight: 7,),
            Text("$email", style: Textstyles.recieverEmail,),
            bio!.isEmpty ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.shrink()
            ) : kCard(
              child: Text("${bio}"),
            )
          ],
        ),
      ),
    );
  }
}
