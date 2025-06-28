import 'package:flutter/material.dart';

class dividerContainer extends StatelessWidget {
  const dividerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * .013, horizontal: MediaQuery.of(context).size.width * .37,
      ),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(7)
      ),
    );
  }
}
