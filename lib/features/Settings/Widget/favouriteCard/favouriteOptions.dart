import 'package:flutter/material.dart';

import '../../../../components/kCard.dart';
import '../../../../components/listTilesOptions.dart';

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
          trailing: Icon(Icons.favorite),
          onTap: (){
            Navigator.of(context).pushNamed("favourite");
          }
      ),
    );
  }
}
