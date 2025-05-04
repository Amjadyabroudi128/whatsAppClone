import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/TextStyles.dart';
import 'package:whatsappclone/components/imageNetworkComponent.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/features/chatScreen/userDetails/StarredMessages.dart';

import '../../../core/MyColors.dart';
import '../../../core/icons.dart';

class userDetails extends StatelessWidget {
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? bio;
  const userDetails({super.key, this.name, this.email, this.imageUrl, this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.BG,
      appBar: AppBar(
        backgroundColor: myColors.BG,
        title: Text("Contact Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
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
                child: Text("${bio}", style: Textstyles.bioStyle,),
              ),
              BoxSpacing(myHeight: 5,),
              kCard(
                color: myColors.familyText,
                child: Options(
                  context: context,
                  leading: icons.star,
                  label: Text("Starred messages"),
                  trailing: icons.arrowForward,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Starredmessages()
                      ),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
