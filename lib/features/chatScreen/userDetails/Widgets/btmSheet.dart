import 'package:flutter/material.dart';

import '../../../../components/iconButton.dart';
import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/MyColors.dart';

Future showBtmSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.grey,
    context: context,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    // ),
    builder: (context) => Container(
      height: 160,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Delete message?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              kIconButton(
                myIcon: Icon(Icons.close),
                onPressed: (){
                  Navigator.pop(context);

                },
              )
            ],
          ),
          SizedBox(height: 20),
          kCard(
            color: Colors.grey[350],
            child: Options(
              onTap: () {
                Navigator.pop(context);
              },
              label: Text("Delete for Everyone", style: TextStyle(color: myColors.redAccent),),
              context: context,
            ),
          ),
        ],
      ),
    ),
  );
}