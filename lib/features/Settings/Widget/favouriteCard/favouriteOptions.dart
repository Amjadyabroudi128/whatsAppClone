import 'package:flutter/material.dart';

import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';
import '../../../../core/icons.dart';

class favouriteCard extends StatelessWidget {
  const favouriteCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kCard(
      child: Options(
          context: context,
          label: Text("Favourite"),
          trailing: icons.myFavourite,
          onTap: (){
            Navigator.of(context).pushNamed("favourite");
          }
      ),
    );
  }
}
