import 'package:flutter/material.dart';

class elevatedBtn extends StatelessWidget {
  const elevatedBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 18)
      ),
      onPressed: (){},
      child: Text("Agree and Continue"),
    );
  }
}
