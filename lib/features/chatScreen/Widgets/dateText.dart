import 'package:flutter/material.dart';

class fomattedDateText extends StatelessWidget {
  const fomattedDateText({
    super.key,
    required this.formattedTime,
  });

  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 45,
      ),
      child: Text(formattedTime),
    );
  }
}
