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
        left: MediaQuery.of(context).size.width * 0.085,
      ),
      child: Text(formattedTime, style: TextStyle(color: Colors.black),),
    );
  }
}
