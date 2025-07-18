import 'package:flutter/material.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/core/TextStyles.dart';
import '../core/icons.dart';
import 'Widgets/circleAvatar.dart';
import 'colorsList.dart';

class Colorpicking extends StatefulWidget {
  const Colorpicking({super.key});

  @override
  _ColorpickingState createState() => _ColorpickingState();
}

class _ColorpickingState extends State<Colorpicking> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        centerTitle: true,
        title:  Text(" Chat Color", style: Textstyles.selectClr),
        iconTheme:  IconThemeData(color: Colors.white),
        backgroundColor: Colors.black54,
      ),
      body: GridView.builder(
        itemCount: colorNames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) {
          Color color = colorNames.keys.elementAt(index);
          String colorName = colorNames[color]!;
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, color); // Return the selected color immediately
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    avatar(color: color),
                    if (selectedIndex == index)
                       icons.tick,
                  ],
                ),
                const BoxSpacing(myHeight: 10),
                Text(colorName, style:  Textstyles.colorName),
              ],
            ),
          );
        },
      ),
    );
  }
}

