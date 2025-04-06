import 'package:flutter/material.dart';

import '../../../components/TextStyles.dart';
import '../../../core/icons.dart';

PopupMenuItem<String> deleteMessage(BuildContext context) {
  return PopupMenuItem<String>(
      value: 'delete',
      child: TextButton(
        onPressed: (){},
        child: Row(
          children: [
            Text("Delete", style: Textstyles.deletemessage),
            Spacer(),
            icons.deleteIcon,
          ],
        ),
      )
  );
}
